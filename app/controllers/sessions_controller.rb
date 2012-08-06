# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  after_filter  :set_session_vars, only: [:create]

  def create
    auth = request.env['omniauth.auth']

    unless @identity = Identity.find_or_create_with_omniauth(auth)
      redirect_to root_url, notice: "Something went wrong. Please try again."
    end

    if signed_in?
      flash[:notice] = @identity.add_to_existing_user(current_user)
    else
      logger.debug @identity.inspect.red_on_white
      ga_event("Users", "#create", @identity.user.name) if flash[:notice] = @identity.create_or_login_user(auth)
    end

    render 'sessions/create'
  end

  def destroy
    self.current_user = nil
    session[:user_id] = nil
    if params[:fb] == "true"
      flash[:error] = "You have been signed out due to a change in your facebook session."
    else
      flash[:success] = "Logged out!"
    end
    cookies.delete :'_sg-just_logged_in'
    cookies.delete :fb_uid
    redirect_to root_url
  end

  private

  def set_session_vars
    if @identity.process_login(DateTime.now, session['_csrf_token'])
      self.current_user = @identity.user
    end

    session['uid'] = @identity.uid
    cookies.encrypted[:fb_uid] = { value: @identity.uid, expires: Time.now + 1800 }
  end
end
