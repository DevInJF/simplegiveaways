# -*- encoding : utf-8 -*-
class FacebookPagesController < ApplicationController

  def show
    @page = FacebookPage.find(params[:id])
    action = @page.giveaways.active.any? || @page.giveaways.pending.empty? ? 'active' : 'pending'
    redirect_to eval "#{action}_facebook_page_giveaways_path(@page)"
  end
end