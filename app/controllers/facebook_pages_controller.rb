# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource through: :current_user

  def show
    @page = FacebookPage.find_by_id(params[:id])

    if @page.active_giveaway
      redirect_to active_facebook_page_giveaways_path(@page)
    else
      redirect_to pending_facebook_page_giveaways_path(@page)
    end
  end
end
