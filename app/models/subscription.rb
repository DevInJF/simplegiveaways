class Subscription < ActiveRecord::Base

  include Stripe::Callbacks

  belongs_to :subscription_plan
  belongs_to :user

  has_many :facebook_pages

  after_customer_subscription_created! do |subscription, event|
    Rails.logger.debug(subscription)
    Rails.logger.debug(event)
  end

  def active?
    true
  end

  def inactive?
    !active?
  end
end
