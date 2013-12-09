class Subscription < ActiveRecord::Base

  include Stripe::Callbacks

  belongs_to :subscription_plan

  has_one  :user
  has_many :facebook_pages

  scope :to_update, -> { where("activate_next_after IS NOT NULL AND activate_next_after <= ? AND next_plan_id >= ?", Time.zone.now, 1) }

  scope :to_cancel, -> { where("activate_next_after IS NOT NULL AND activate_next_after <= ? AND next_plan_id < ?", Time.zone.now, 1) }

  after_customer_subscription_created! do |subscription, event|
    Rails.logger.debug(subscription)
    Rails.logger.debug(event)
  end

  def active?
    subscription_plan.present?
  end

  def inactive?
    !active?
  end

  def subscribe_pages(pages)
    self.facebook_pages = select_pages(pages)
    save!
  end

  def cancel_plan
    self.subscription_plan = nil
    self.activate_next_after = nil
    self.next_plan_id = nil
    save
  end

  def update_plan
    self.subscription_plan_id = next_plan_id
    self.activate_next_after = nil
    self.next_plan_id = nil
    save
  end

  class << self

    def schedule_worker
      Subscription.to_cancel.each(&:cancel_plan)
      Subscription.to_update.each(&:update_plan)
    end
  end

  private

  def select_pages(pages)
    pages.select do |page|
      page.subscription_id.nil? || page.subscription_id == self.id || page.subscription_plan < self.subscription_plan
    end
  end
end
