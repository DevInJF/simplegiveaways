class SubscriptionsController < ApplicationController

  before_filter :assign_ivars

  respond_to :json

  def create
    begin
      if update_sg_subscription
        render json: { redirect_path: redirect_path }
      else
        head :unprocessable_entity
      end
    rescue Stripe::CardError => error
      respond_with error
    end
  end

  def destroy
    begin
      if cancel_sg_subscription
        flash[:info] = "You were successfully unsubscribed from the #{@subscription_plan.name} plan. You will be able to enjoy the benefits of your subscription until the end of the current billing cycle. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
      else
        flash[:error] = "We were unable to unsubscribe you from the #{@subscription_plan.name} plan. Please try again or contact support for assistance."
      end
      redirect_to user_subscription_plans_path(current_user)
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
    @facebook_pages = if params[:facebook_page_ids]
      params[:facebook_page_ids].map { |pid| FacebookPage.find_by_id(pid) }
    else
      current_user.facebook_pages
    end
  end

  def update_sg_subscription
    if @subscription = current_user.subscription
      assess_update_type
      @subscription.subscription_plan = @subscription_plan
      @subscription.save
    else
      @subscription = @subscription_plan.subscriptions.create(user: current_user)
    end

    after_update
  end

  def cancel_sg_subscription
    if @subscription = current_user.subscription
      @cancellation = true
      @subscription_plan = @subscription.subscription_plan

      if cancel_stripe_subscription
        @subscription.activate_next_after = @subscription.current_period_end
        @subscription.next_plan_id = 0
        @subscription.save
      end
    end
  end

  def after_update
    if @subscription.subscribe_pages(@facebook_pages)
      stripe_response = update_stripe_subscription

      @subscription.current_period_start = DateTime.strptime("#{stripe_response.current_period_start}", '%s')
      @subscription.current_period_end = DateTime.strptime("#{stripe_response.current_period_end}", '%s')

      if @downgrade
        @subscription.activate_next_after = @subscription.current_period_end
        @subscription.next_plan_id = @subscription.subscription_plan.id
      end

      @subscription.save
    else
      false
    end
  end

  def assess_update_type
    if @subscription.subscription_plan < @subscription_plan
      @upgrade = true
    elsif @subscription.subscription_plan > @subscription_plan
      @downgrade = true
    end
  end

  def update_stripe_subscription
    find_or_create_customer
    @customer.update_subscription(stripe_update_options)
  end

  def cancel_stripe_subscription
    find_or_create_customer
    @customer.cancel_subscription(stripe_update_options)
  end

  def stripe_update_options
    defaults = { plan: @subscription_plan.stripe_subscription_id }
    if @upgrade
      defaults.merge(prorate: true)
    elsif @downgrade
      defaults.merge(prorate: false)
    elsif @cancellation
      { at_period_end: true }
    else
      defaults
    end
  end

  def redirect_path
    if session[:return_to]
      session.delete(:return_to)
    else
      user_subscription_plans_path(current_user)
    end
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
