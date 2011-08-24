class UsersController < ApplicationController
  
  respond_to :html, :xml, :json
  
  before_filter :authenticate_user!
  
  def edit
    @user = User.find(params[:id])
    @credit_card = @user.credit_cards.build
    @credit_card.build_billing_address
  end
  
  def update
    @user = User.find(params[:id])
    @user.credit_cards_attributes = params[:user][:credit_cards_attributes]

    if @user.save
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