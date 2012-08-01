class Like < ActiveRecord::Base

  attr_accessible :entry_id, :giveaway_id, :ref_ids,
                  :fb_uid, :from_entry

  belongs_to :giveaway
  belongs_to :entry

  serialize :ref_ids, Array

  def self.create_from_cookie(giveaway_cookie)
    Rails.logger.debug(giveaway_cookie.inspect.magenta)
    Like.create(
      from_entry: giveaway_cookie.entry_id.present?,
      fb_uid: giveaway_cookie.uid,
      entry_id: giveaway_cookie.entry_id,
      ref_ids: giveaway_cookie.ref_ids,
      giveaway_id: giveaway_cookie.giveaway_id
    )
  end

  def ga_hash
    { giveaway_id: giveaway_id,
      page_id: giveaway.facebook_page.id,
      entry_id: entry_id
    }.to_json
  end
end
