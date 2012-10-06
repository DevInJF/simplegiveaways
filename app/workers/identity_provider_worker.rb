class IdentityProviderWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :critical

  def perform(identity, auth)
    Identity.provider_worker(identity, auth)
  end
end
