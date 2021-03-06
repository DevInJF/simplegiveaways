# -*- encoding : utf-8 -*-
require 'csv'

class Giveaway < ActiveRecord::Base

  is_impressionable

  attr_accessible :title, :description, :start_date, :end_date, :prize, :terms,
                  :preferences, :sticky_post, :preview_mode, :giveaway_url,
                  :facebook_page_id, :image, :feed_image, :custom_fb_tab_name,
                  :analytics, :active, :terms_url, :terms_text, :autoshow_share_dialog,
                  :allow_multi_entries, :email_required, :bonus_value, :_total_shares,
                  :_total_wall_posts, :_total_sends, :_total_requests, :_viral_entry_count, :_views,
                  :_uniques, :_viral_views, :_viral_like_count, :_likes_from_entries_count,
                  :_entry_count, :_entry_rate, :_conversion_rate, :_page_likes_while_active

  has_many :audits, as: :auditable

  belongs_to :facebook_page
  has_many :entries
  has_many :likes

  scope :active, lambda {
    where("active IS TRUE")
  }
  scope :pending, lambda {
    where("active IS FALSE AND end_date >= ? OR end_date IS NULL", Time.zone.now)
  }
  scope :completed, lambda {
    where("active IS FALSE AND end_date <= ?", Time.zone.now)
  }
  scope :to_start, lambda {
    where("start_date IS NOT NULL AND active IS FALSE AND start_date <= ? AND start_date > ?",
          Time.zone.now + 3.minutes, Time.zone.now - 20.minutes)
  }
  scope :to_end, lambda {
    where("end_date IS NOT NULL AND active IS TRUE AND end_date <= ?", Time.zone.now + 3.minutes)
  }

  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: :facebook_page_id }
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :prize, presence: true
  validates :custom_fb_tab_name, presence: true

  validates_attachment_presence :image
  validates_attachment_presence :feed_image

  store :terms, accessors: [ :terms_url, :terms_text ]

  validate :terms_present
  validates :terms_url, format: { with: /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
                                  message: "must be a proper URL and start with 'http://'" }, allow_blank: true

  store :preferences, accessors: [ :autoshow_share_dialog,
                                   :allow_multi_entries,
                                   :email_required,
                                   :bonus_value ]

  validates :autoshow_share_dialog, presence: true, inclusion: { in: [ "true", "false" ] }
  validates :allow_multi_entries, presence: true, inclusion: { in: [ "true", "false" ] }
  validates :email_required, presence: true, inclusion: { in: [ "true", "false" ] }
  validates :bonus_value, presence: true, numericality: { only_integer: true }

  store :sticky_post, accessors: [ :sticky_post_enabled?,
                                   :sticky_post_title,
                                   :sticky_post_body ]

  validates :sticky_post_title, presence: true, length: { maximum: 200 }, if: -> { sticky_post_enabled? }
  validates :sticky_post_body, presence: true, if: -> { sticky_post_enabled? }

  validates_datetime :start_date, is_at: -> { start_date_was },
                                  is_at_message: "cannot be changed on an active giveaway.",
                                  on: :update,
                                  if: -> { active_was },
                                  ignore_usec: true

  validates_datetime :start_date, on_or_after: -> { 5.minutes.ago },
                                  on_or_after_message: "must be in the future.",
                                  unless: -> { active || active_was },
                                  ignore_usec: true

  validates_datetime :start_date, before: :end_date,
                                  before_message: "must be before end date/time.",
                                  ignore_usec: true

  validates_datetime :end_date, on_or_after: -> { (Time.zone.now - 30.seconds) },
                                on_or_after_message: "must be in the future.",
                                ignore_usec: true

  validates_datetime :end_date, after: :start_date,
                                after_message: "must be after start date/time.",
                                ignore_usec: true

  store :analytics, accessors: [ :_total_shares,
                                 :_total_wall_posts,
                                 :_total_sends,
                                 :_total_requests,
                                 :_viral_entry_count,
                                 :_views,
                                 :_uniques,
                                 :_viral_views,
                                 :_viral_like_count,
                                 :_likes_from_entries_count,
                                 :_page_likes_while_active,
                                 :_entry_count,
                                 :_entry_rate,
                                 :_conversion_rate ]

  has_attached_file :image,
    styles: {
      medium: "300x300>",
      gallery: "256x320#",
      tab: "810"
    },
    convert_options: {
      medium: "-quality 75 -strip",
      gallery: "-quality 70 -strip"
    },
    storage: :s3,
    s3_credentials: S3_CREDENTIALS,
    s3_protocol: "https",
    path: "/:style/:id/:filename"

  has_attached_file :feed_image,
    styles: {
      thumb: "111x74#",
      feed: "90x90>"
    },
    convert_options: {
      thumb: "-quality 75 -strip",
      feed: "-quality 70 -strip"
    },
    storage: :s3,
    s3_credentials: S3_CREDENTIALS,
    s3_protocol: "https",
    path: "/:style/:id/:filename"


  def graph_client
    @graph ||= Koala::Facebook::API.new(facebook_page.token)
  end

  def csv
    CSV.generate do |csv|
      csv << ["ID", "Email", "Name", "Viral?", "New Fan?", "Entry Time",
              "Wall Posts", "Sends", "Requests", "Conversions", "Bonus Entries"]
      entries.each do |entry|
        csv << [entry.id, entry.email, entry.name, entry.is_viral,
                entry.new_fan?, entry.datetime_entered, entry.wall_post_count,
                entry.send_count, entry.request_count, entry.convert_count, entry.bonus_entries]
      end
    end
  end

  def publish(giveaway_params = {})
    return false unless startable?
    if self.update_attributes(giveaway_params.merge({ start_date: (Time.zone.now - 30.seconds), active: true }))
      is_installed? ? update_tab : create_tab
      after_publish
    else
      false
    end
  end

  def after_publish
    save_shortlink
    GabbaClient.new.event(category: "Giveaways", action: "Giveaway#start", label: title)
    facebook_page.users.each do |page_admin|
      GiveawayNoticeMailer.start(page_admin, self).deliver rescue nil
    end
  end

  def save_shortlink
    self.shortlink = bitly_client.shorten(giveaway_url).short_url rescue giveaway_url
    save
  end

  def bitly_client
    Bitly.use_api_version_3
    Bitly.new(BITLY_USERNAME, BITLY_KEY)
  end

  def unpublish
    self.end_date = Time.zone.now
    self.active = false
    save ? after_unpublish : false
  end

  def after_unpublish
    if delete_tab
      GabbaClient.new.event(category: "Giveaways", action: "Giveaway#end", label: title)
      facebook_page.users.each do |page_admin|
        GiveawayNoticeMailer.end(page_admin, self).deliver rescue nil
      end
    else
      false
    end
  end

  def startable?
    facebook_page.giveaways.active.empty? rescue false
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
    !active && (end_date.nil? || (end_date >= Time.zone.now))
  end

  def completed?
    !active && end_date <= Time.zone.now
  end

  def is_installed?
    graph_client.get_connections("me", "tabs", tab: FB_APP_ID).any? ? true : false
  end

  def create_tab
    graph_client.put_connections("me", "tabs", app_id: FB_APP_ID)
    update_tab
  end

  def update_tab
    tabs = graph_client.get_connections("me", "tabs")
    tab = tabs.select do |tab|
            tab["application"] && tab["application"]["namespace"] == "simplegiveaways"
          end.compact.flatten.first

    put_tab
  rescue Koala::Facebook::APIError
    put_tab(false)
  end

  def delete_tab
    tabs = graph_client.get_connections("me", "tabs")
    tab = select_giveaway_tab(tabs)

    graph_client.delete_object(tab["id"]) ? true : false
  end

  def put_tab(position = 0)
    options = { tab: "app_#{FB_APP_ID}",
                custom_name: custom_fb_tab_name,
                custom_image_url: feed_image(:thumb) }
    options.merge(position: 0) if position
    graph_client.put_object( facebook_page.pid, "tabs", options )
  end

  def select_giveaway_tab(tabs)
    tabs.select do |tab|
      tab["application"] && tab["application"]["namespace"] == "simplegiveaways"
    end.compact.flatten.first
  end

  def page_pid
    facebook_page.pid
  end

  def total_shares
    total_wall_posts + total_sends + total_requests
  end

  def total_wall_posts
    all_wall_posts = entries.collect(&:wall_post_count)
    all_wall_posts.inject(:+) || 0
  end

  def total_sends
    all_sends = entries.collect(&:send_count)
    all_sends.inject(:+) || 0
  end

  def total_requests
    all_requests = entries.collect(&:request_count)
    all_requests.inject(:+) || 0
  end

  def viral_entry_count
    entries.where(:is_viral => true).size
  end

  def views
    impressionist_count
  end

  def ip_uniques
    unique_impression_count_ip
  end

  def fb_user_uniques
    impressions.where("message LIKE ?", "%fb_uid: %").map do |impression|
      YAML.load(impression.message)[:message].match(/fb_uid: ([A-Za-z0-9]*)/)
      $1
    end.uniq.count
  rescue StandardError
    0
  end

  def viral_views
    impressions.where("message LIKE ?", "%ref_id: %").size
  end

  def viral_like_count
    viral_likes.size
  end

  def viral_likes
    likes.where(:is_viral => true)
  end

  def likes_from_entries_count
    likes_from_entries.size
  end

  def likes_from_entries
    likes.where("from_entry IS TRUE")
  end

  def page_likes_while_active
    active? ? page_likes_so_far : audits.last.is[:analytics][:_page_likes_while_active]
  rescue StandardError
    0
  end

  def page_likes_so_far
    facebook_page.likes - page_likes_at_start
  rescue StandardError
    0
  end

  def page_likes_at_start
    facebook_page.audits.
        where('created_at < ?', start_date.utc).
        sort.last.is[:likes].to_i
  end

  def page_likes_at_end
    facebook_page.audits.
        where('created_at > ?', end_date.utc).
        sort.first.is[:likes].to_i
  end

  def entry_count
    entries.size
  end

  def entry_rate
    entry_count > 0 ? "#{((entry_count.to_f / uniques.to_f) * 100).round(2)}%" : "N/A"
  rescue StandardError
    0
  end

  def conversion_rate
    entry_count > 0 ? "#{((viral_entry_count.to_f / (total_shares.to_f)) * 100).round(2)}%" : "N/A"
  rescue StandardError
    0
  end

  def refresh_analytics
    self._total_shares = total_shares
    self._total_wall_posts = total_wall_posts
    self._total_sends = total_sends
    self._total_requests = total_requests
    self._viral_entry_count = viral_entry_count
    self._views = views
    self._uniques = uniques
    self._viral_views = viral_views
    self._viral_like_count = viral_like_count
    self._page_likes_while_active = page_likes_while_active
    self._likes_from_entries_count = likes_from_entries_count
    self._entry_count = entry_count
    self._entry_rate = entry_rate
    self._conversion_rate = conversion_rate
    self.audits << analytics_audit
    save
  end

  def tab_height
    Giveaway.image_dimensions(image(:tab))[:height].to_i + 203
  end

  def countdown_target
    end_date.strftime("%m/%d/%Y %H:%M:%S")
  end

  def terms_link
    terms_url.present? ? terms_url_link : terms_text_link
  end

  class << self

    def cookie_key(id)
      "_sg_gid_#{id}".to_sym
    end

    def image_dimensions(img_url)
      dimensions = Paperclip::Geometry.from_file(img_url).to_s.split("x") rescue []
      { width: dimensions[0], height: dimensions[1] }
    end

    def tab(signed_request)
      app_data = signed_request["app_data"]
      referrer_id = app_data.split("ref_")[1] rescue []
      current_page = FacebookPage.select("id, url, name").find_by_pid(signed_request["page"]["id"])
      giveaway = current_page.giveaways.detect(&:active?)

      OpenStruct.new({
        fb_uid: signed_request["user_id"],
        referrer_id: referrer_id,
        has_liked: signed_request["page"]["liked"],
        current_page: current_page,
        giveaway: giveaway.tab_attrs,
        tab_height: giveaway.tab_height
      })
    end

    def app_request_worker(request_id, signed_request)
      return unless signed_request
      oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = oauth.parse_signed_request(signed_request)

      return unless signed_request["oauth_token"]
      graph = Koala::Facebook::API.new(signed_request["oauth_token"])
      graph.delete_object "#{request_id}_#{signed_request["user_id"]}"
    end

    def schedule_worker(method)
      Giveaway.to_start.each(&:publish) if method == "publish"
      Giveaway.to_end.each(&:unpublish) if method == "unpublish"
    end

    def uniques_worker(giveaway_id)
      @giveaway = Giveaway.find_by_id(giveaway_id)
      @giveaway.uniques += 1
      @giveaway.save
    end
  end

  def tab_attrs
    OpenStruct.new({
      id: id,
      title: title,
      description: description,
      giveaway_url: giveaway_url,
      image_url: self.image.url(:tab).gsub("http://", "https://"),
      feed_image_url: self.feed_image.url.gsub("http://", "https://"),
      bonus_value: bonus_value,
      terms_text: terms_text,
      terms_link: terms_link,
      autoshow_share: autoshow_share_dialog,
      auth_required: email_required
    })
  end

  private

  def terms_url_link
    "<a href='#{terms_url}' class='terms-link terms-url' target='_blank'>Official Terms and Conditions</a>".html_safe
  end

  def terms_text_link
    "<a href='#' class='terms-link terms-text'>Official Terms and Conditions</a>".html_safe
  end

  def terms_present
    if terms_url.blank? && terms_text.blank?
      errors.add(:terms_url, "Must provide either Terms URL or Terms Text.")
      errors.add(:terms_text, "Must provide either Terms URL or Terms Text.")
    end
  end

  def analytics_audit
    Audit.new(
      was: { analytics: analytics_was },
      is: { analytics: analytics }
    )
  end
end
