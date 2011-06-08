class CreditCardsController < ApplicationController
  def index
    @credit_cards = CreditCard.all
  end

  def show
    @credit_card = CreditCard.find(params[:id])
  end

  def new
    @credit_card = CreditCard.new
  end

  def create
    @credit_card = CreditCard.new(params[:credit_card])
    if @credit_card.save
      redirect_to @credit_card, :notice => "Successfully created credit card."
    else
      render :action => 'new'
    end
  end

  def edit
    @credit_card = CreditCard.find(params[:id])
  end

  def update
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.update_attributes(params[:credit_card])
      redirect_to @credit_card, :notice  => "Successfully updated credit card."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @credit_card = CreditCard.find(params[:id])
    @credit_card.destroy
    redirect_to credit_cards_url, :notice => "Successfully destroyed credit card."
  end
end
