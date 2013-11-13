Rails.configuration.stripe = OpenStruct.new({
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY'],
  :api_key         => ENV['STRIPE_SECRET_KEY']
})

Stripe.api_key = Rails.configuration.stripe.secret_key

StripeTester.webhook_url = 'http://0.0.0.0:8000/stripe/events'
