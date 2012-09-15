class GiveawayUniquesWorker
  include Sidekiq::Worker

  def perform(giveaway_id)
    Giveaway.uniques_worker(giveaway_id)
  end
end
