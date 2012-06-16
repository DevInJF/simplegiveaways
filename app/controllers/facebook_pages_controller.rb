# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  def show
    @page = FacebookPage.find(params[:id])
    if @page.giveaways
      action = "active"
      redirect_to eval "#{action}_facebook_page_giveaways_path(@page)"
    else
      redirect_to root_path
    end
  end
end
