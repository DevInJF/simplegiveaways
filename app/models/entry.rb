# -*- encoding : utf-8 -*-
class Entry < ActiveRecord::Base

  audited

  belongs_to :giveaway
  has_many :viral_likes

  validates :email, :uniqueness => { :scope => :giveaway_id }

  attr_accessor :referer_id

  class << self

    def count_conversion(has_liked, referer_id)
      Rails.logger.debug("POOPIEPANTS".yellow)
      Rails.logger.debug(self.inspect.yellow)
      Rails.logger.debug(referer_id.inspect.magenta)
      if has_liked && referer_id != "[]"
        @ref = Entry.find_by_id(referer_id)
        @ref.convert_count += 1
        @ref.save
      end
    end
    handle_asynchronously :count_conversion
  end

  def process(*args)
    options = args.extract_options!

    @referer_id = options[:referrer_id]

    graph = Koala::Facebook::API.new(options[:access_token])
    profile = graph.get_object("me")

    Rails.logger.debug(profile.inspect.red_on_white)

    @existing_entry = Entry.find_by_uid(profile["id"])

    Rails.logger.debug(@existing_entry.inspect.green_on_white)

    unless @existing_entry

      self.uid = profile["id"]
      self.name = profile["name"]
      self.email = profile["email"]
      self.fb_url = profile["link"]
      self.datetime_entered = DateTime.now

      Rails.logger.debug(self.inspect.blue_on_white)

      status = self.determine_status(options[:has_liked], options[:access_token]).has_liked

      Rails.logger.debug(self.inspect.green_on_white)

      Entry.count_conversion(status, referer_id) if status

      Rails.logger.debug(self.inspect.red_on_white)

      @entry = self

      Rails.logger.debug(@entry.inspect.red_on_white)
    end

    Rails.logger.debug((@entry ||= @existing_entry).inspect.cyan)

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
    status = rest.fql_query("SELECT uid FROM page_fan WHERE uid=#{uid} AND page_id=#{giveaway.facebook_page.pid}")
    status[0].nil? ? false : true
  end
end
