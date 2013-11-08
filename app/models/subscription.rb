class Subscription < ActiveRecord::Base

  belongs_to :subscription_plan
  belongs_to :user

  has_many :facebook_pages

  def active?

  end

  def inactive?
    !active?
  end
end
