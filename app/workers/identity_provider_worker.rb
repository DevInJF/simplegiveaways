class IdentityProviderWorker
  include Sidekiq::Worker

  def perform(identity, auth)
    Identity.provider_worker(identity, auth)
  end
end
