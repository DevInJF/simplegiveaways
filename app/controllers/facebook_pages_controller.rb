# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource through: :current_user

  def index
    partial = render_to_string(partial: 'users/facebook_pages')

    respond_to do |format|
      format.json do
        render json: {
          complete: current_user.finished_onboarding?,
          html: "#{partial}"
        }.to_json
      end
    end
  end

  def show
    @page = FacebookPage.find_by_id(params[:id])

    if params.has_key?(:subscribed)
      flash[:info] = "#{@page.name} has been successfully subscribed to the #{@page.subscription_plan_name} plan. Thank you for using <strong>Simple Giveaways</strong>.".html_safe
      redirect_to pending_facebook_page_giveaways_path(@page, subscribed: true)
    elsif @page.active_giveaway
      flash.keep
      redirect_to active_facebook_page_giveaways_path(@page)
    else
      flash.keep
      redirect_to pending_facebook_page_giveaways_path(@page)
    end
  end
end
