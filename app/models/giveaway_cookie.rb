class GiveawayCookie

  attr_accessor :giveaway_id, :ref_ids, :wasnt_fan, :is_fan

  def initialize(cookie)
    @last_cookie = deserialize_cookie(cookie)
    @giveaway_id = @last_cookie['giveaway_id'] if @last_cookie
    @ref_ids = @last_cookie['ref_ids'] ? @last_cookie['ref_ids'] : []
    @wasnt_fan = @last_cookie['wasnt_fan'] if @last_cookie
    @is_fan = @last_cookie['is_fan'] if @last_cookie
  end

  def update_cookie(giveaway_hash)
    self.giveaway_id = giveaway_hash.giveaway.id

    if giveaway_hash.referrer_id.present?
      logger.debug(self.inspect)
      self.ref_ids = ref_ids.push(giveaway_hash.referrer_id.to_i).uniq
    end

    if giveaway_hash.has_liked
      self.is_fan = true
    else
      self.wasnt_fan ||= true
    end
  end

  def as_json(options={ })
    { :giveaway_id => giveaway_id,
      :ref_ids => ref_ids,
      :wasnt_fan => wasnt_fan,
      :is_fan => is_fan }
  end


  private

  def deserialize_cookie(cookie)
    ActiveSupport::JSON.decode(cookie) rescue {}
  end
end