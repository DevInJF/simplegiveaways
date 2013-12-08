class SubscriptionPlansController < ApplicationController

  layout Proc.new { |controller| params[:facebook_page_id] ? 'facebook_pages' : 'users' }

  before_filter :set_return_path

  def index
    @scheduling = true if params[:scheduling]
    @page = FacebookPage.find_by_id(params[:facebook_page_id])
    @subscription_plans = SubscriptionPlan.public
  end

  private

  def set_return_path
    session[:return_to] ||= request.referer
  end
end
