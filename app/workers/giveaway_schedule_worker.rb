class GiveawayScheduleWorker
  include Sidekiq::Worker

  def perform(method)
    Giveaway.schedule_worker(method)
  end
end
