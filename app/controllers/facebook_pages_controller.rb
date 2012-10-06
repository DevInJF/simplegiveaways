# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource through: :current_user

  def show
    @page = FacebookPage.find(params[:id])
    redirect_to active_facebook_page_giveaways_path(@page)
  end
end
