class Transaction < ActiveRecord::Base
  belongs_to :user
  serialize :params
  
  after_create :activate_page, :activate_giveaway

  def response=(response)
    self.success       = response.success?
    self.authorization = response.transaction.processor_response_code
    self.message       = response.transaction.processor_response_text
    self.params        = response
  rescue StandardError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
    self.params        = {}
  end
  
  def self.price_in_cents(price)
    (price*100).round
  end
  
  private
  
  def activate_page
    if success?
      
    end
  end
  
  def activate_giveaway
    if success?
      
    end
  end
end