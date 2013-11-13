class SubscriptionsController < ApplicationController

  respond_to :json

  def create
    begin
      if update_subscription
        head :ok
      else
        head :unprocessable_entity
      end
    rescue Stripe::CardError => error
      respond_with error
    end
  end

  private

  def update_subscription
    find_or_create_customer
    @customer.update_subscription(plan: params[:stripe_subscription_id], prorate: true)
  end

  def find_or_create_customer
    if current_user.stripe_customer_id
      @customer = current_user.stripe_customer
    else
      @customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripe_token]
      )
      current_user.stripe_customer_id = @customer.id
      current_user.save
    end
  end
end
