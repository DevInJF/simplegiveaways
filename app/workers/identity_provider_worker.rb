class IdentityProviderWorker
  include Sidekiq::Worker

  def perform(identity, auth)
    @identity = Identity.find_by_id(identity["id"])
    @identity.auth = auth
    if @identity.set_provider_data!
      @identity.save
    end
  end
end