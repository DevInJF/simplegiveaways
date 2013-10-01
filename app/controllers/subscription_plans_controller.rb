class SubscriptionPlansController < ApplicationController

  def index
    @facebook_page = FacebookPage.find_by_id(params[:facebook_page_id])
    @subscription_plans = SubscriptionPlan.all
  end
end
