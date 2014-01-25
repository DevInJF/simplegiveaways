# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource through: :current_user

  def index
    if request.xhr?
      current_pids = current_user.facebook_page_ids
      pids = current_pids - params[:pids].split(",").map(&:to_i)
      html = ""
      pids.each do |pid|
        html += render_to_string(partial: 'facebook_pages/preview', locals: { facebook_page: FacebookPage.find(pid) })
      end

      flash.clear

      if current_user.finished_onboarding?
        flash[:success] = { title: "Successfully fetched your Facebook Pages.", content: "You can now start building your first giveaway. Thank you for using <strong>Simple Giveaways</strong>".html_safe }
        header_nav_html = render_to_string(partial: 'layouts/navigation/my_pages')
        sidebar_nav_html = render_to_string(partial: 'layouts/navigation/sidebar/facebook_pages', locals: { active: false })
        new_giveaway_html = render_to_string(partial: 'components/new_giveaway_dropdown')
      end
    end

    respond_to do |format|
      format.json do
        render json: {
          complete: current_user.finished_onboarding?,
          html: "#{html}",
          header_nav_html: "#{header_nav_html}",
          sidebar_nav_html: "#{sidebar_nav_html}",
          new_giveaway_html: "#{new_giveaway_html}",
          pids: current_pids
        }.to_json
      end
    end
  end

  def show
    @page = FacebookPage.find(params[:id])

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
