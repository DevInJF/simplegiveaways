class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address, :dependent => :destroy

  accepts_nested_attributes_for :billing_address
end