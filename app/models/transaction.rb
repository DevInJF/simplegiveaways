class Transaction < ActiveRecord::Base
  belongs_to :user
  serialize :params

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
end