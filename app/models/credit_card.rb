class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address, :dependent => :destroy

  accepts_nested_attributes_for :billing_address
  
  validates :number, :presence => true, :uniqueness => { :scope => :user_id }
  validates :month, 
            :year, 
            :first_name, 
            :last_name, 
            :verification_value, 
            :card_type, 
            :presence => true
end