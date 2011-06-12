class Entry < ActiveRecord::Base
  belongs_to :giveaway

  validates :email, :uniqueness => {:scope => :giveaway_id}
end