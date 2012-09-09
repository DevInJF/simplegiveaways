# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  before_filter :parse_signed_request, only: [:deauth]

  def show
    redirect_to root_path unless @user = current_user
  end

  def deauth
    if @user = User.find_by_id(@signed_request["user_id"])
      @user.identities.where(:provider => 'facebook').each(&:destroy)
    end
  end

  private

  def parse_signed_request
    oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    @signed_request = oauth.parse_signed_request(params[:signed_request])
  end
end
