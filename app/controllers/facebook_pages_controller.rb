# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource :through => :current_user

  def show
    @page = FacebookPage.find(params[:id])
    if @page.giveaways
      redirect_to active_facebook_page_giveaways_path(@page)
    else
      redirect_to root_path
    end
  end
end
