class GiveawayUniquesWorker
  include Sidekiq::Worker

  def perform(options = {})
    Giveaway.uniques_worker(options)
  end
end
