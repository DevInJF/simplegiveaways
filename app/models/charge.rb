class Charge < ActiveRecord::Base

  include Stripe::Callbacks

  after_charge_succeeded! do |charge, event|
    Rails.logger.debug(charge)
    Rails.logger.debug(event)
  end

  after_charge_failed! do |charge, event|
    Rails.logger.debug(charge)
    Rails.logger.debug(event)
  end
end
