# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  def show
    unless @user = current_user
      redirect_to root_path
    end
  end
end
