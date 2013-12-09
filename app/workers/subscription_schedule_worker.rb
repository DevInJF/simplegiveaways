class SubscriptionScheduleWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :critical

  def perform
    Subscription.schedule_worker
  end
end
