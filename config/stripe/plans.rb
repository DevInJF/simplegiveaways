Stripe.plan :single_page_unlimited_monthly do |plan|
  plan.name = 'Single Page Unlimited (monthly)'
  plan.amount = 1500
  plan.interval = 'month'
end

Stripe.plan :single_page_unlimited_yearly do |plan|
  plan.name = 'Single Page Unlimited (yearly)'
  plan.amount = 15000
  plan.interval = 'year'
end

Stripe.plan :multi_page_unlimited_monthly do |plan|
  plan.name = 'Multi Page Unlimited (monthly)'
  plan.amount = 4500
  plan.interval = 'month'
end

Stripe.plan :multi_page_unlimited_yearly do |plan|
  plan.name = 'Multi Page Unlimited (yearly)'
  plan.amount = 45000
  plan.interval = 'year'
end
