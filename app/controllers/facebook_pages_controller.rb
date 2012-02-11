class FacebookPagesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_page

  def show

  end

  private

  def get_page
    @page = FacebookPage.find(params[:id])
  end
end