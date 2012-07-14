# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  def show
    if @user = current_user
      @key = session['jug']
    else
      redirect_to root_path
    end
  end
end
