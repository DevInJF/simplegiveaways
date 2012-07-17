# -*- encoding : utf-8 -*-
class Giveaway < ActiveRecord::Base

  is_impressionable

  has_many :audits, :as => :auditable

  belongs_to :facebook_page
  has_many :entries
  has_many :likes

  scope :active, lambda {
    where("start_date IS NOT NULL && end_date IS NOT NULL && start_date <= ? && end_date >= ?", Time.now, Time.now).limit(1)
  }
  scope :pending, lambda {
    where("start_date >= ? && end_date >= ? OR start_date IS NULL OR end_date IS NULL", Time.now, Time.now)
  }
  scope :completed, lambda {
    where("start_date IS NOT NULL && end_date IS NOT NULL && start_date <= ? && end_date <= ?", Time.now, Time.now)
  }

  validates :title, :presence => true, :length => { :maximum => 100 }, :uniqueness => { :scope => :facebook_page_id }
  validates :title, :presence => true, :length => { :maximum => 100 }
  validates :description, :presence => true
  validates :prize, :presence => true
  validates :custom_fb_tab_name, :presence => true

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

  validate :unchanged_active_start_date, :on => :update
  validate :end_in_future
  validate :start_in_future, :on => :create
  validate :pending_start_in_future


  store :analytics, accessors: [ :_total_shares,
                                 :_total_wall_posts,
                                 :_total_requests,
                                 :_total_conversions,
                                 :_views,
                                 :_uniques,
                                 :_viral_views,
                                 :_viral_like_count,
                                 :_likes_from_entries_count,
                                 :_entry_count,
                                 :_entry_rate,
                                 :_conversion_rate ]

  has_attached_file :image,
    :styles => {
      :medium => "300x300>", 
      :gallery => "256x320#",
      :tab => "810"
    },
    :convert_options => {
      :medium => "-quality 75 -strip",
      :gallery => "-quality 70 -strip"
    },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"
    
  has_attached_file :feed_image,
    :styles => {
      :thumb  => "111x74#",
      :feed => "90x90>"
    },
    :convert_options => {
      :thumb => "-quality 75 -strip",
      :feed => "-quality 70 -strip"
    },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/:style/:id/:filename"


  def graph_client
    @graph ||= Koala::Facebook::API.new(facebook_page.token)
  end

  def publish(giveaway_params)
    return false unless startable?
    if self.update_attributes(giveaway_params.merge({ :start_date => Time.now, :active => true }))
      is_installed? ? update_tab : create_tab
    else
      false
    end
  end

  def startable?
    facebook_page.giveaways.active.empty? ? true : false
  end

  def status
    case
    when pending?
      "Pending"
    when completed?
      "Completed"
    when active?
      "Active"
    else
      nil
    end
  end

  def active?
    active
  end

  def pending?
    start_date.nil? || end_date.nil? || (start_date > Time.now && end_date > Time.now)
  end

  def completed?
    start_date < Time.now && end_date < Time.now
  end
  
  def is_installed?
    graph_client.get_connections("me", "tabs", :tab => FB_APP_ID).any? ? true : false
  end

  def create_tab
    graph_client.put_connections("me", "tabs", :app_id => FB_APP_ID)
    update_tab
  end

  def update_tab
    tabs = graph_client.get_connections("me", "tabs")
    tab = tabs.select do |tab|
            tab["application"] && tab["application"]["namespace"] == "simplegiveaways"
          end.compact.flatten.first

    graph_client.put_object( facebook_page.pid, "tabs", :tab => "app_#{FB_APP_ID}", 
                                                        :custom_name => custom_fb_tab_name, 
                                                        :custom_image_url => feed_image(:thumb) )
  end

  def delete_tab   
    tabs = graph_client.get_connections("me", "tabs")
    tab = tabs.select do |tab|
            tab["application"] && tab["application"]["namespace"] == "simplegiveaways"
          end.compact.flatten.first

    graph_client.delete_object(tab["id"])
  end

  def total_shares
    total_wall_posts + total_requests
  end

  def total_wall_posts
    all_wall_posts = entries.collect(&:wall_post_count)
    all_wall_posts.inject(:+) || 0
  end

  def total_requests
    all_requests = entries.collect(&:request_count)
    all_requests.inject(:+) || 0
  end

  def total_conversions
    all_conversions = entries.collect(&:convert_count)
    all_conversions.inject(:+) || 0
  end

  def views
    impressionist_count
  end

  def uniques
    impressionist_count(:filter => :session_hash)
  end

  def viral_views
    Impression.find(:all, :conditions => ["message LIKE ?", "%ref_id: %"]).size
  end

  def viral_like_count
    viral_likes.size
  end

  def viral_likes
    likes.where("entry_id != 0")
  end

  def likes_from_entries_count
    likes.size
  end

  def page_likes_while_active
    active? ? page_likes_so_far : (page_likes_at_end - page_likes_at_start)
  rescue StandardError
    "N/A"
  end

  def page_likes_so_far
    facebook_page.likes - page_likes_at_start
  rescue StandardError
    "N/A"
  end

  def page_likes_at_start
    facebook_page.audits.
        where('created_at < ?', start_date).
        sort.last.
        audited_changes["likes"].last.to_i
  end

  def page_likes_at_end
    facebook_page.audits.
        where('created_at > ?', end_date).
        sort.first.
        audited_changes["likes"].last.to_i
  end

  def total_page_likes
    facebook_page.like_count
  end

  def entry_count
    entries.size
  end

  def entry_rate
    entry_count > 0 ? "#{((uniques.to_f / entry_count.to_f) * 100).round(2)}%" : "N/A"
  rescue StandardError
    0
  end

  def conversion_rate
    entry_count > 0 ? "#{((total_conversions.to_f / (total_shares.to_f)) * 100).round(2)}%" : "N/A"
  rescue StandardError
    0
  end

  def refresh_analytics
    self._total_shares = total_shares
    self._total_wall_posts = total_wall_posts
    self._total_requests = total_requests
    self._total_conversions = total_conversions
    self._views = views
    self._uniques = uniques
    self._viral_views = viral_views
    self._viral_like_count = viral_like_count
    self._likes_from_entries_count = likes_from_entries_count
    self._entry_count = entry_count
    self._entry_rate = entry_rate
    self._conversion_rate = conversion_rate
    self.audits << analytics_audit
    save
  end

  def tab_height
    Giveaway.image_dimensions(image(:tab))[:height].to_i + 50
  end

  class << self

    def image_dimensions(img_url)
      dimensions = Paperclip::Geometry.from_file(img_url).to_s.split("x") rescue []
      { :width => dimensions[0], :height => dimensions[1] }
    end

    def tab(signed_request)
      app_data = signed_request["app_data"]
      referrer_id = app_data.split("ref_")[1] rescue []
      current_page = FacebookPage.select("id, url, name").find_by_pid(signed_request["page"]["id"])
      giveaway = current_page.giveaways.detect(&:active?)

      OpenStruct.new({
        :referrer_id => referrer_id,
        :has_liked => signed_request["page"]["liked"],
        :current_page => current_page,
        :giveaway => giveaway,
        :tab_height => giveaway.tab_height
      })
    end

    def delete_app_request(request_id, signed_request)
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = oauth.parse_signed_request(signed_request)

      graph = Koala::Facebook::API.new(signed_request["oauth_token"])
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

  def pending_start_in_future
    if pending? && start_date.present? && (start_date < (Time.now - 5.minutes))
      errors.add(:start_date, "must be in the future.")
    end
  end

  def start_in_future
    if start_date < Time.now
      errors.add(:start_date, "must be in the future.")
    end
  end

  def unchanged_active_start_date
    if start_date_changed? && active_was
      errors.add(:start_date, "cannot be changed on an active giveaway.")
      false
    else
      true
    end
  end

  def start_date_changed?
    start_date_was.to_formatted_s(:long) != start_date.to_formatted_s(:long)
  end

  def analytics_audit
    Audit.new(
      :was => { :analytics => analytics_was },
      :is => { :analytics => analytics }
    )
  end
end