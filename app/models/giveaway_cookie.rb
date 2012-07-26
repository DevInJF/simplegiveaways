class GiveawayCookie

  attr_accessor :giveaway_id, :ref_ids, :wasnt_fan, :is_fan, :like_counted

  def initialize(cookie=nil)
    @last_cookie = deserialize_cookie(cookie)
    logger.debug(@last_cookie.inspect.white_on_magenta)
    @giveaway_id = @last_cookie["giveaway_id"]
    @ref_ids = @last_cookie["ref_ids"] ? @last_cookie["ref_ids"] : []
    @wasnt_fan ||= @last_cookie["wasnt_fan"]
    @is_fan ||= @last_cookie["is_fan"]
    @like_counted ||= @last_cookie["like_counted"] || false
  end

  def uncounted_viral_like
    !!is_fan && !!wasnt_fan && !like_counted
  end

  def update_cookie(giveaway_hash)
    Rails.logger.debug("giveawaycookie is #{self.inspect}".inspect.cyan)
    Rails.logger.debug("giveaway_hash is #{giveaway_hash.inspect}".inspect.red)
    self.giveaway_id = giveaway_hash.giveaway.id

    if giveaway_hash.referrer_id.present?
      self.ref_ids = ref_ids.push(giveaway_hash.referrer_id.to_i).uniq
    end

    if giveaway_hash.has_liked
      self.is_fan = true
    else
      self.wasnt_fan = true
      self.is_fan = false
    end
  end

  def as_json(options={ })
    { :giveaway_id => giveaway_id,
      :ref_ids => ref_ids,
      :wasnt_fan => wasnt_fan,
      :is_fan => is_fan,
      :like_counted => like_counted }
  end

  private

  def deserialize_cookie(cookie=nil)
    ActiveSupport::JSON.decode(cookie) rescue {}
  end
end