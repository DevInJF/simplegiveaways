# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  protected

  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) || Identity.find_by_uid(cookies[:fb_uid]).user if cookies[:fb_uid])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? user : user.id
  end
end
