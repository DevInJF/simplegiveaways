class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def purchase
    response = Braintree::Transaction.sale(
      :amount => "25000.00",
      :credit_card => {
        :number => "5105105105105100",
        :expiration_date => "05/12"
      }
    )
    transaction = Transaction.create!(
      :product => "test",
      :amount => price_in_cents(25000.00),
      :response => response
    )
    transaction.update_attribute(:purchased_at, Time.now) if response.success?

    if response.success?
      flash["success"] = "Purchase was successful."
      redirect_to user_path(current_user)
    else
      flash["error"] = "Purchase was unsuccessful."
      redirect_to user_path(current_user)
    end
  end

  def price_in_cents(price)
    (price*100).round
  end
end