# -*- encoding : utf-8 -*-
module ApplicationHelper

  def active_nav_item(item)
    controller.action_name == "#{item}" ? "active" : ""
  end

  def body_class
    "#{controller.controller_name} #{controller.action_name}"
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
    render(:partial => "users/facebook_pages")
  end
end
