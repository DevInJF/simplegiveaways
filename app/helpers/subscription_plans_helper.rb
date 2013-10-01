module SubscriptionPlansHelper

  def stripe_button(plan, facebook_page_name)
    haml_tag :script, class: 'stripe-button', "data-amount" => "#{plan.price_in_cents_per_cycle}", "data-name" => "Simple Giveaways", "data-description" => "#{plan.name}", "data-label" => "Pay #{plan.price}", "data-key" => Rails.configuration.stripe[:publishable_key], :src => "https://checkout.stripe.com/v2/checkout.js"
  end
end
