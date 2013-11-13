class SubscriptionPlan < ActiveRecord::Base

  has_many :subscriptions

  validates :name, uniqueness: true

  scope :public, where("price_in_cents_per_cycle > ?", 0)

  def stripe_subscription_id
    name.downcase.gsub(/\s/, '_').gsub(/\(|\)/, '')
  end

  def price
    "$#{price_in_cents_per_cycle / 100}.00"
  end

  def is_free_trial?
    price_in_cents_per_cycle == 0
  end
end
