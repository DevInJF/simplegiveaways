class BillingAddress < ActiveRecord::Base
  belongs_to :credit_card
end