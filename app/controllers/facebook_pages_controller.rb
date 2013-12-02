# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource through: :current_user

  def show
    @page = FacebookPage.find_by_id(params[:id])

    if params.has_key?(:subscribed)
      flash[:info] = "#{@page.name} has been successfully subscribed to the #{@page.subscription_plan_name} plan. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
      redirect_to pending_facebook_page_giveaways_path(@page, subscribed: true)
    elsif @page.active_giveaway
      redirect_to active_facebook_page_giveaways_path(@page)
    else
      redirect_to pending_facebook_page_giveaways_path(@page)
    end
  end
end
