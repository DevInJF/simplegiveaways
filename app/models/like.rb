class Like < ActiveRecord::Base

  attr_accessible :entry_id, :giveaway_id, :ref_ids,
                  :fb_uid, :from_entry

  belongs_to :giveaway
  belongs_to :entry

  serialize :ref_ids, Array

  after_save :assess_virality

  def self.create_from_cookie(giveaway_cookie)
    Like.create(
      from_entry: giveaway_cookie.entry_id.present?,
      fb_uid: giveaway_cookie.uid,
      entry_id: giveaway_cookie.entry_id,
      ref_ids: giveaway_cookie.ref_ids,
      giveaway_id: giveaway_cookie.giveaway_id
    )
  end

  private

  def assess_virality
    self.is_viral = true if ref_ids.any?
    save if is_viral_changed?
  end
end
