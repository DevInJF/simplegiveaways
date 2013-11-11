class SubscriptionPlansController < ApplicationController

  layout 'facebook_pages'

  def index
    @page = FacebookPage.find_by_id(params[:facebook_page_id])
    @subscription_plans = SubscriptionPlan.public
  end
end
