# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :set_juggernaut_token, only: [:create]
  after_filter  :set_session_vars, only: [:create]

  def create
    auth = request.env['omniauth.auth']

    unless @identity = Identity.find_or_create_with_omniauth(auth)
      redirect_to root_url, notice: "Something went wrong. Please try again."
    end

    if signed_in?
      flash[:notice] = @identity.add_to_existing_user(current_user)
    else
      flash[:notice] = @identity.create_or_login_user(auth)
    end

    render 'sessions/create'
  end

  def destroy
    self.current_user = nil
    if params[:fb] == "true"
      flash[:error] = "You have been signed out due to a change in your facebook session."
    else
      flash[:success] = "Logged out!"
    end
    cookies.delete :fb_uid
    redirect_to root_url
  end

  private

  def set_juggernaut_token
    @jug = session['jug'] = Juggernaut.create_key("users#show")
  end

  def set_session_vars
    if @identity.process_login(DateTime.now, @jug)
      self.current_user = @identity.user
    end

    session['uid'] = @identity.uid
    cookies[:fb_uid] = { value: @identity.uid, expires: Time.now + 1800 }
  end
end
