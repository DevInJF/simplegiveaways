module SubscriptionPlansHelper

  def stripe_button(plan, facebook_page_name)
    haml_tag :script, class: 'stripe-button', "data-amount" => "#{plan.price_in_cents_per_cycle}", "data-name" => "Simple Giveaways", "data-description" => "#{plan.name}", "data-label" => button_label(plan), "data-key" => Rails.configuration.stripe[:publishable_key], :src => "https://checkout.stripe.com/v2/checkout.js"
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
end
