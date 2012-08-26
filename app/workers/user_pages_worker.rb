class UserPagesWorker
  include Sidekiq::Worker

  def perform(user, csrf_token)
    User.pages_worker(user, csrf_token)
  end
end
