# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    auth = request.env['omniauth.auth']

    unless @identity = Identity.find_or_create_with_omniauth(auth)
      redirect_to root_url, notice: "Something went wrong. Please try again."
    end

    if signed_in?
      if @identity.user == current_user
        redirect_to root_url, notice: "Already linked that account!"
      else
        @identity.user = current_user
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      unless @identity.user.present?
        @identity.create_user(:name => auth["info"]["name"])
      end
      self.current_user = @identity.user
      redirect_to root_url, notice: "Logged in!"
    end
    @identity.process_login(DateTime.now)
  end

  def destroy
    self.current_user = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
