class SubscriptionsController < ApplicationController

  before_filter :assign_ivars

  respond_to :json

  def create
    begin
      if update_stripe_subscription && update_sg_subscription
        head :ok
      else
        head :unprocessable_entity
      end
    rescue Stripe::CardError => error
      respond_with error
    end
  end

  private

  def assign_ivars
    assign_subscription_plan
    assign_facebook_pages
  end

  def assign_subscription_plan
    @subscription_plan = SubscriptionPlan.find_by_id(params[:subscription_plan_id])
  end

  def assign_facebook_pages
    if @subscription_plan.is_single_page?
      @facebook_pages = [FacebookPage.find_by_id(params[:facebook_page_id])]
    else
      @facebook_pages = current_user.facebook_pages
    end
  end

  def update_sg_subscription
    @subscription = @subscription_plan.subscriptions.create(user: current_user)
    @facebook_pages.each do |page|
      page.update_attributes(subscription_id: @subscription.id)
    end
  end

  def update_stripe_subscription
    find_or_create_customer
    @customer.update_subscription(plan: @subscription_plan.stripe_subscription_id, prorate: true)
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
