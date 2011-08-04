class FacebookPagesController < ApplicationController

  before_filter :authenticate_user!

  def show
    @page = FacebookPage.find(params[:id])
  end
end