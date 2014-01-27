class SubscriptionsController < ApplicationController

  respond_to :html

  def create
    begin
      if @subscription = update_sg_subscription
        session[:just_subscribed] = true
        flash[:info] = { title: "You were successfully subscribed.", content: "You are now subscribed to the #{current_user.subscription_plan_name} plan. Thank you for using <strong>Simple Giveaways</strong>.".html_safe }
      else
        flash[:error] = { title: "An unknown error occurred.", content: "We were unable to process your subscription request. Please try again or contact support for assistance. We apologize for the inconvenience." }
      end
      redirect_to redirect_path
    rescue Stripe::CardError => error
      flash[:error] = { title: "An unknown error occurred.", content: "We were unable to process your subscription request. Please try again or contact support for assistance. We apologize for the inconvenience." }
      redirect_to redirect_path
    end
  end

  def destroy
    begin
      if @subscription = cancel_sg_subscription
        flash[:info] = { title: "You were successfully unsubscribed.", content: "You will still be able to enjoy the benefits of your subscription until the end of the current billing cycle. Thank you for using <strong>Simple Giveaways</strong>.".html_safe }
      else
        flash[:error] = { title: "An unknown error occurred.", content: "We were unable to unsubscribe you from your plan. Please try again or contact support for assistance. We apologize for the inconvenience." }
      end
      redirect_to user_subscription_plans_path(current_user)
    rescue Stripe::CardError => error
      respond_with error
    end
  end

  private

  def update_sg_subscription
    Subscription.create_or_update(
      user_id: current_user.id,
      subscription_plan_id: params[:subscription_plan_id],
      stripe_token: params[:stripe_token],
      facebook_page_ids: facebook_page_ids
    )
  end

  def cancel_sg_subscription
    Subscription.cancel(user_id: current_user.id)
  end

  def facebook_page_ids
    params[:facebook_page_ids] || current_user.facebook_page_ids
  end

  def redirect_path
    if session[:return_to]
      session.delete(:return_to)
    else
      user_subscription_plans_path(current_user)
    end
  end
end
