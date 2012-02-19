# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  def show
    @page = FacebookPage.find(params[:id])
  end
end
