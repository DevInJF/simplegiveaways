# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id], :include => :facebook_pages)
  end
end
