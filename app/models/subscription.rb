class Subscription < ActiveRecord::Base

  include Stripe::Callbacks

  belongs_to :subscription_plan

  has_one  :user
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

  def subscribe_pages(pages)
    self.facebook_pages = select_pages(pages)
    save!
  end

  private

  def select_pages(pages)
    pages.select do |page|
      page.subscription_id.nil? || page.subscription_id == self.id || page.subscription_plan < self.subscription_plan
    end
  end
end
