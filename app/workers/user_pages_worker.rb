class UserPagesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :critical

  def perform(user, fb_token, csrf_token)
    User.pages_worker(user, fb_token, csrf_token)
  end
end
