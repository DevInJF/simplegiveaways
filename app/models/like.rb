class Like < ActiveRecord::Base

  attr_accessible :entry_id, :giveaway_id

  belongs_to :giveaway
  belongs_to :entry
end
