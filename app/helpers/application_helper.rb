# -*- encoding : utf-8 -*-
module ApplicationHelper

  def body_class
    "#{controller.controller_name} #{controller.action_name}"
  end

  def page_heading
    content_for(:page_heading) || controller.controller_name
  end

  def sidebar_content
    content_for(:sidebar) || ""
  end
end
