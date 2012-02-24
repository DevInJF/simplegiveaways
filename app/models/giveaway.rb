# -*- encoding : utf-8 -*-
class Giveaway < ActiveRecord::Base

  is_impressionable

  belongs_to :facebook_page
  has_many :entries

  validates :title, :presence => true, :uniqueness => { :scope => :facebook_page_id }
  validates :description, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :prize, :presence => true
  validates :terms, :presence => true

  validates_attachment_presence :image
  validates_attachment_presence :feed_image

  store :preferences, accessors: [ :autoshow_share_dialog,
                                   :allow_multi_entries,
                                   :bonus_value,
                                   :preview ]

  validates :autoshow_share_dialog, :inclusion => { :in => [ true, false ] }
  validates :allow_multi_entries, :inclusion => { :in => [ true, false ] }
  validates :bonus_value, :numericality => { :only_integer => true }
  validates :preview, :inclusion => { :in => [ true, false ] }

  validate :end_in_future

  has_attached_file :image,
    :styles => {
      :thumb  => "150x150>",
      :medium => "300x300>" },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"
    
  has_attached_file :feed_image,
    :styles => {
      :thumb  => "45x45>",
      :feed => "90x90>" },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"

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

  def end_in_future
    if end_date < start_date
      errors[:base] << "End date must be in the future"
    end
  end
end
