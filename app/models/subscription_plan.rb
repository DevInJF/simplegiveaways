class SubscriptionPlan < ActiveRecord::Base

  include Comparable

  has_many :subscriptions

  validates :name, uniqueness: true

  scope :public, where("price_in_cents_per_cycle > ?", 0)

  PLAN_HIERARCHY = [
    { name: "Single Page",
      weight: 0 },
    { name: "Single Page Pro",
      weight: 1 },
    { name: "Multi Page Pro",
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

  def canhaz_basic_analytics?
    !canhaz_advanced_analytics?
  end

  def canhaz_advanced_analytics?
    name.include? 'Pro'
  end

  def canhaz_scheduled_giveaways?
    name.include? 'Pro'
  end

  def canhaz_referral_tracking?
    name.include? 'Pro'
  end

  def canhaz_giveaway_shortlink?
    name.include? 'Pro'
  end

  def canhaz_white_label?
    name.include? 'Pro'
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

    def single_page
      self.find_or_create_by_name(
        name: "Single Page",
        description: "Run unlimited giveaways on one of your pages.",
        price_in_cents_per_cycle: 700,
        is_single_page: true,
        is_multi_page: false,
        is_onetime: false,
        is_monthly: true,
        is_yearly: false
      )
    end

    def single_page_pro
      self.find_or_create_by_name(
        name: "Single Page Pro",
        description: "Run unlimited giveaways on one of your pages. Track viral sharing and referrals, gain insights from advanced analytics, and remove Simple Giveaways branding from your giveaways.",
        price_in_cents_per_cycle: 1500,
        is_single_page: true,
        is_multi_page: false,
        is_onetime: false,
        is_monthly: true,
        is_yearly: false
      )
    end

    def multi_page_pro
      self.find_or_create_by_name(
        name: "Multi Page Pro",
        description: "Run unlimited giveaways on any of your pages. Track viral sharing and referrals, gain insights from advanced analytics, and remove Simple Giveaways branding from your giveaways.",
        price_in_cents_per_cycle: 4500,
        is_single_page: false,
        is_multi_page: true,
        is_onetime: false,
        is_monthly: true,
        is_yearly: false
      )
    end
  end
end
