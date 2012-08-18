# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base

  before_filter :user_pages, :if => :signed_in?

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  protected

  def user_pages
    @user_pages ||= current_user.facebook_pages.select([:id, :pid, :name]) rescue nil
  end

  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) || Identity.find_by_uid(cookies[:_sg_uid]).user if cookies[:_sg_uid]) rescue nil
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?, :user_pages

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? user : user.id
  end
end
