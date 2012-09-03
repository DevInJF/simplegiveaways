# -*- encoding : utf-8 -*-
class Entry < ActiveRecord::Base

  attr_accessible :email, :has_liked, :name, :fb_url, :datetime_entered,
                  :wall_post_count, :request_count, :convert_count,
                  :status, :uid, :ref_ids, :referrer_id, :is_viral

  has_many :audits, as: :auditable

  belongs_to :giveaway
  has_many :likes

  validates :email, uniqueness: { scope: :giveaway_id }

  attr_accessor :referrer_id

  serialize :ref_ids, Array

  def process(*args)
    options = args.extract_options!

    @cookie = options[:cookie]
    @referrer_id = options[:referrer_id].blank? ? nil : options[:referrer_id].to_i

    graph = Koala::Facebook::API.new(options[:access_token])
    profile = graph.get_object("me")

    @existing_entry = Entry.find_by_uid_and_giveaway_id(profile["id"], options[:giveaway_id])

    logger.debug(@cookie.inspect.cyan)
    logger.debug(@referrer_id.inspect.red)
    logger.debug(@existing_entry.inspect.white)

    unless @existing_entry

      self.entry_count = 1
      self.uid = profile["id"]
      self.name = profile["name"]
      self.email = profile["email"]
      self.fb_url = profile["link"]
      self.datetime_entered = DateTime.now

      if @cookie.belongs_to_user && @referrer_id
        self.ref_ids = @cookie.ref_ids.push(@referrer_id).uniq
      else
        self.ref_ids = [@referrer_id].compact
      end

      self.is_viral = self.ref_ids.any? ? true : false

      status = self.determine_status(options[:has_liked], options[:access_token]).has_liked

      EntryConversionWorker.perform_async(status, ref_ids, @cookie) if status && ref_ids.any?

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

  def new_fan?
    likes.any?
  end

  def bonus_entries
    giveaway.bonus_value.to_i * convert_count rescue 0
  end

  def self.conversion_worker(has_liked, ref_ids, giveaway_cookie)
    if has_liked
      puts giveaway_cookie.inspect.red
      ref_ids.uniq.each do |ref|
        puts ref.inspect.green_on_white
        if @ref = Entry.find_by_id_and_giveaway_id(ref, giveaway_cookie['giveaway_id'])
          @ref.convert_count += 1
          @ref.save
        end
      end
    end
  end
end
