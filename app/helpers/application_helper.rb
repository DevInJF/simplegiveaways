# -*- encoding : utf-8 -*-
module ApplicationHelper

  def page_heading
    content_for(:page_heading) || controller.controller_name
  end

  def sidebar_content
    content_for(:sidebar) || ""
  end
end
