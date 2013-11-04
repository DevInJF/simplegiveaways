# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  load_and_authorize_resource through: :current_user

  def show
    @page = FacebookPage.find_by_id(params[:id])
  end
end
