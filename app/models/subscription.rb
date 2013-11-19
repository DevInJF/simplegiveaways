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
    pages.each do |page|
      page.has_active_subscription? ? handle_subscribed_page(page) : subscribe_page(page)
    end
  end

  private

  def subscribe_page(page)
    page.update_attributes(subscription_id: self.id)
    self.update_attributes(quantity: quantity + 1) if subscription_plan.is_single_page?
  end

  def handle_subscribed_page(page)
    subscribe_page(page) if page.subscription_plan < self.subscription_plan
  end
end
