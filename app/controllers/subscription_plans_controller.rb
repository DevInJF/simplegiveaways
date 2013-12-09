class SubscriptionPlansController < ApplicationController

  layout Proc.new { |controller| params[:facebook_page_id] ? 'facebook_pages' : 'users' }

  def index
    if request.post? && params[:starting]
      session[:return_to] ||= request.referer
      head :ok
    else
      @scheduling = true if params[:scheduling]
      @page = FacebookPage.find_by_id(params[:facebook_page_id])
      @subscription_plans = SubscriptionPlan.public
    end
  end
end
