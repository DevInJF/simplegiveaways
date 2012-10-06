class UserPagesWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :critical

  def perform(user, csrf_token)
    User.pages_worker(user, csrf_token)
  end
end
