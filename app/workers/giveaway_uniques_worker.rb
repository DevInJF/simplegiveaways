class GiveawayUniquesWorker
  include Sidekiq::Worker

  def perform(giveaway_id, is_fan)
    Giveaway.uniques_worker(giveaway_id, is_fan)
  end
end
