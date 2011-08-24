class UsersController < ApplicationController
  
  respond_to :html, :xml, :json
  
  before_filter :authenticate_user!
  
  def edit
    @user = User.find(params[:id])
    @credit_card = @user.credit_cards.first || @user.credit_cards.build
    @billing_address = @credit_card.billing_address || @credit_card.build_billing_address
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:success] = 'User was successfully updated.'
      redirect_to(@user)
    else
      render :action => "edit"
    end
  end
  
  def show
    @user = User.find(params[:id], :include => [:facebook_pages])
  end
end