class Utils

  class << self

    def clean_subscriptions
      User.all.map do |u|

        begin
          customer = Stripe::Customer.retrieve(u.stripe_customer_id)
          customer.delete
        rescue => e
          puts e.inspect.red
        end

        u.subscription_id = nil
        u.stripe_customer_id = nil
        u.save
      end

      FacebookPage.all.map do |fp|
        fp.subscription_id = nil
        fp.save
      end

      Subscription.destroy_all
    end
  end
end
