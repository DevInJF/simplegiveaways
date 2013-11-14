class SubscriptionPlan < ActiveRecord::Base

  include Comparable

  has_many :subscriptions

  validates :name, uniqueness: true

  scope :public, where("price_in_cents_per_cycle > ?", 0)

  PLAN_HIERARCHY = [
    { name: "Single Page Unlimited (monthly)",
      weight: 0 },
    { name: "Single Page Unlimited (yearly)",
      weight: 1 },
    { name: "Multi Page Unlimited (monthly)",
      weight: 1 },
    { name: "Multi Page Unlimited (yearly)",
      weight: 2 }
  ]

  def weight
    plan = PLAN_HIERARCHY.select do |plan_hash|
      plan_hash[:name] == self.name
    end.pop
    plan[:weight]
  end

  def <=>(another_plan)
    self.weight <=> another_plan.weight
  end

  def price
    "$#{price_in_cents_per_cycle / 100}.00"
  end

  def is_free_trial?
    price_in_cents_per_cycle == 0
  end

  def stripe_subscription_id
    name.downcase.gsub(/\s/, '_').gsub(/\(|\)/, '')
  end

  class << self

    def free_trial
      self.find_or_create_by_name(
        name: "Free Trial",
        description: "Run a free giveaway on your page.",
        price_in_cents_per_cycle: 0,
        is_single_page: true,
        is_multi_page: false,
        is_onetime: true,
        is_monthly: false,
        is_yearly: false
      )
    end

    def single_page_monthly
      self.find_or_create_by_name(
        name: "Single Page Unlimited (monthly)",
        description: "Run unlimited giveaways on your page.",
        price_in_cents_per_cycle: 1500,
        is_single_page: true,
        is_multi_page: false,
        is_onetime: false,
        is_monthly: true,
        is_yearly: false
      )
    end

    def single_page_yearly
      self.find_or_create_by_name(
        name: "Single Page Unlimited (yearly)",
        description: "Run unlimited giveaways on your page.",
        price_in_cents_per_cycle: 15000,
        is_single_page: true,
        is_multi_page: false,
        is_onetime: false,
        is_monthly: false,
        is_yearly: true
      )
    end

    def multi_page_monthly
      self.find_or_create_by_name(
        name: "Multi Page Unlimited (monthly)",
        description: "Run unlimited giveaways on any of your pages.",
        price_in_cents_per_cycle: 4500,
        is_single_page: false,
        is_multi_page: true,
        is_onetime: false,
        is_monthly: true,
        is_yearly: false
      )
    end

    def multi_page_yearly
      self.find_or_create_by_name(
        name: "Multi Page Unlimited (yearly)",
        description: "Run unlimited giveaways on any of your pages.",
        price_in_cents_per_cycle: 45000,
        is_single_page: false,
        is_multi_page: true,
        is_onetime: false,
        is_monthly: false,
        is_yearly: true
      )
    end
  end
end
