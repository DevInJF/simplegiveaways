# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  def show
    redirect_to root_path unless @user = current_user
  end
end
