class GiveawayScheduleWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :critical

  def perform(method)
    Giveaway.schedule_worker(method)
  end
end
