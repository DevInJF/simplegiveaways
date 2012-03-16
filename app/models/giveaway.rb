# -*- encoding : utf-8 -*-
class Giveaway < ActiveRecord::Base

  is_impressionable

  belongs_to :facebook_page
  has_many :entries

  scope :active, lambda {
    where("start_date IS NOT NULL && end_date IS NOT NULL && start_date < ? && end_date > ?", Time.now, Time.now)
  }
  scope :pending, lambda {
    where("start_date > ? && end_date > ? OR start_date IS NULL OR end_date IS NULL", Time.now, Time.now)
  }
  scope :completed, lambda {
    where("start_date IS NOT NULL && end_date IS NOT NULL && start_date < ? && end_date < ?", Time.now, Time.now)
  }

  validates :title, :presence => true, :length => { :maximum => 100 }, :uniqueness => { :scope => :facebook_page_id }
  validates :description, :presence => true
  validates :prize, :presence => true

  validates_attachment_presence :image
  validates_attachment_presence :feed_image

  store :terms, accessors: [ :terms_url, :terms_text ]

  validate :terms_present

  store :preferences, accessors: [ :autoshow_share_dialog,
                                   :allow_multi_entries,
                                   :email_required,
                                   :bonus_value ]

  validates :autoshow_share_dialog, :presence => true, :inclusion => { :in => [ "true", "false" ] }
  validates :allow_multi_entries, :presence => true, :inclusion => { :in => [ "true", "false" ] }
  validates :email_required, :presence => true, :inclusion => { :in => [ "true", "false" ] }
  validates :bonus_value, :presence => true, :numericality => { :only_integer => true }

  store :sticky_post, accessors: [ :sticky_post_enabled?,
                                   :sticky_post_title,
                                   :sticky_post_body ]

  validates :sticky_post_title, :presence => true, :length => { :maximum => 200 }, :if => lambda { sticky_post_enabled? }
  validates :sticky_post_body, :presence => true, :if => lambda { sticky_post_enabled? }

  validate :end_in_future

  has_attached_file :image,
    :styles => {
      :thumb  => "150x150>",
      :medium => "300x300>", 
      :gallery => "256x320#"},
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"
    
  has_attached_file :feed_image,
    :styles => {
      :thumb  => "45x45>",
      :feed => "90x90>"},
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"


  def startable?
    # Can the giveaway be started safely?
    true
  end

  def status
    case
    when start_date.nil? || end_date.nil? || (start_date > Time.now && end_date > Time.now)
      "Pending"
    when start_date < Time.now && end_date < Time.now
      "Completed"
    when start_date < Time.now && end_date > Time.now
      "Active"
    else
      nil
    end
  end

  def is_live?
    now = Time.now
    start_date < now && end_date > now ? true : false
  end
  
  def is_installed?
    if facebook_page.has_added_app.nil?
      @graph = Koala::Facebook::API.new(facebook_page.token)
      @graph.fql_query("SELECT has_added_app FROM page WHERE page_id=#{facebook_page.pid}")[0]["has_added_app"]
    else
      facebook_page.has_added_app
    end
  end

  def count_conversion(ref)
    ref = entries.find(ref)
    ref.convert_count += 1
    ref.save
  end
  handle_asynchronously :count_conversion

  def total_shares
    all_shares = entries.collect(&:share_count)
    all_shares.inject(:+) || 0
  end

  def total_requests
    all_requests = entries.collect(&:request_count)
    all_requests.inject(:+) || 0
  end

  def total_conversions
    all_conversions = entries.collect(&:convert_count)
    all_conversions.inject(:+) || 0
  end

  def conversion_rate
    "#{((total_conversions.to_f / (total_shares.to_f + total_requests.to_f)) * 100).round(2)}%"
  rescue StandardError
    0
  end

  class << self

    def tab(signed_request)
      app_data = signed_request["app_data"]
      referrer_id = app_data.split("ref_")[1] rescue []
      current_page = FacebookPage.select("id, url, name").find_by_pid(signed_request["page"]["id"])

      OpenStruct.new({
        "referrer_id" => referrer_id,
        "has_liked" => signed_request["page"]["liked"],
        "current_page" => current_page,
        "giveaway" => current_page.giveaways.detect(&:is_live?)
      })
    end

    def delete_app_request(request_id, signed_request)
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      graph = Koala::Facebook::API.new(FB_APP_TOKEN)
      signed_request = oauth.parse_signed_request(signed_request)

      graph.delete_object "#{request_id}_#{signed_request["user_id"]}"
    end
    handle_asynchronously :delete_app_request
  end

  private

  def terms_present
    if terms_url.blank? && terms_text.blank?
      errors.add(:terms_url, "Must provide either Terms URL or Terms Text.")
      errors.add(:terms_text, "Must provide either Terms URL or Terms Text.")
    end
  end

  def end_in_future
    if end_date.present? && start_date.present?
      if end_date < start_date || end_date == start_date
        errors.add(:end_date, "cannot be earlier than start date.")
      end
    end
  end
end
