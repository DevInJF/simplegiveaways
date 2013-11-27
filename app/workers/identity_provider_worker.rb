class IdentityProviderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :critical

  def perform(identity_id, auth)
    Identity.provider_worker(identity_id, auth)
  end
end
