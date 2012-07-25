class Like < ActiveRecord::Base

  attr_accessible :entry_id, :giveaway_id, :ref_ids

  belongs_to :giveaway
  belongs_to :entry

  serialize :ref_ids

  def self.create_from_cookie(giveaway_cookie)
    Like.create(
      ref_ids: giveaway_cookie.ref_ids,
      giveaway_id: giveaway_cookie.giveaway_id
    )
  end
end
