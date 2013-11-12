class ChargesController < ApplicationController

  respond_to :json

  def create
    begin
      @customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripe_token]
      )

      @customer.update_subscription(plan: Stripe::Plans::SINGLE_PAGE_UNLIMITED_MONTHLY, prorate: true)

      respond_with @customer
    rescue Stripe::CardError => error
      respond_with error
    end
  end
end
