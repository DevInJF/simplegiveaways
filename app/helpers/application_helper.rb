# -*- encoding : utf-8 -*-
module ApplicationHelper

  def current_host_url
    request.env['HTTP_HOST']
  end

  def active_nav_item(item)
    controller.action_name == "#{item}" ? "active" : ""
  end

  def body_class
    "#{controller.controller_name} #{controller.action_name}"
  end

  def uid_class
    session['uid'] || cookies[:fb_uid]
  end

  def auth_class
    current_user.present? ? "logged-in" : "logged-out"
  end

  def flash_class(level)
    case level
    when :notice
      "alert"
    when :success
      "alert alert-success"
    when :error
      "alert alert-error"
    when :alert
      "alert alert-error"
    else
      "alert alert-info"
    end
  end

  def page_heading
    content_for(:page_heading) || controller.controller_name
  end

  def sidebar_content
    render(partial: "users/facebook_pages")
  end

  def datetime_mdy(datetime)
    datetime.strftime('%m/%d/%Y') rescue ""
  end
end
