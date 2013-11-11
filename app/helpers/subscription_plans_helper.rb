module SubscriptionPlansHelper

  def stripe_button(plan)
    haml_tag :script, class: 'stripe-button', "data-amount" => "#{plan.price_in_cents_per_cycle}", "data-name" => "Simple Giveaways", "data-description" => "#{plan.name}", "data-label" => button_label(plan), "data-key" => Rails.configuration.stripe[:publishable_key], :src => "https://checkout.stripe.com/v2/checkout.js"
  end

  def subscription_plan_id(plan)
    plan.name.gsub(/\s|\(|\)/, '')
  end

  def button_label(plan)
    if plan.is_free_trial?
      "FREE"
    elsif plan.is_onetime?
      plan.price
    elsif plan.is_monthly?
      "#{plan.price}/mo"
    elsif plan.is_yearly?
      "#{plan.price}/yr"
    end
  end

  def basic_plan_name_string(plan)
    plan.name.gsub(/\s\(.*\)/, '')
  end

  def plan_recurring_string(plan)
    plan.name.match(/\s\(.*\)/)[0]
  end

  def page_count_feature_string(plan)
    plan.is_single_page? ? '1 Facebook Page' : 'Unlimited Facebook Pages'
  end

  def giveaway_count_feature_string(plan)
    plan.is_free_trial? ? '1 Giveaway' : 'Unlimited Giveaways'
  end

  def white_label_feature_string(plan)
    str = plan.is_yearly? ? 'White-label Service' : '<strike>White-label Service</strike>'
    str.html_safe
  end
end
