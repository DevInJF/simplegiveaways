class Utils

  class << self

    def clean_subscriptions
      unless Rails.env.production?
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

    def clean_data
      unless Rails.env.production?
        Giveaway.destroy_all
        Entry.destroy_all
        Like.destroy_all
        FacebookPage.destroy_all
        User.destroy_all
        Impression.destroy_all
      end
    end
  end
end
