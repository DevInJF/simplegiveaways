# -*- encoding : utf-8 -*-
class Entry < ActiveRecord::Base

  attr_accessible :email, :has_liked, :name, :fb_url, :datetime_entered,
                  :wall_post_count, :request_count, :convert_count,
                  :status, :uid

  has_many :audits, as: :auditable

  belongs_to :giveaway
  has_many :likes

  validates :email, uniqueness: { scope: :giveaway_id }

  attr_accessor :referer_id

  def process(*args)
    options = args.extract_options!

    @referer_id = options[:referrer_id]

    graph = Koala::Facebook::API.new(options[:access_token])
    profile = graph.get_object("me")

    @existing_entry = Entry.find_by_uid(profile["id"])

    unless @existing_entry

      self.uid = profile["id"]
      self.name = profile["name"]
      self.email = profile["email"]
      self.fb_url = profile["link"]
      self.datetime_entered = DateTime.now

      status = self.determine_status(options[:has_liked], options[:access_token]).has_liked

      EntryConversionWorker.perform_async(status, referer_id) if status

      @entry = self
    end

    @entry ||= @existing_entry
  end

  def determine_status(has_liked, access_token)
    if has_liked == "true"
      self.has_liked = true
      self.status = "complete"
    else
      if like_status(access_token) == false
        self.has_liked = false
        self.status = "incomplete"
      else
        self.has_liked = true
        self.status = "complete"
      end
    end

    self
  end

  def like_status(access_token)
    rest = Koala::Facebook::API.new(access_token)
    status = rest.fql_query("SELECT uid FROM page_fan WHERE uid=#{uid} AND page_id=#{giveaway.page_pid}")
    status[0].nil? ? false : true
  end
end
