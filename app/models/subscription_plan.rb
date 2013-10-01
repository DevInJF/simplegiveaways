class SubscriptionPlan < ActiveRecord::Base

  has_many :subscriptions

  validates :name, uniqueness: true

  def price
    "$#{price_in_cents_per_cycle / 100}.00"
  end

  def is_free_trial?
    self == self.class.free_trial
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
