class GiveawayScheduleWorker
  include Sidekiq::Worker

  def perform
    Giveaway.schedule_worker
  end
end
