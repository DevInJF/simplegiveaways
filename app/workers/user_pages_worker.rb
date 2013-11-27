class UserPagesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :critical

  def perform(user_id, fb_token, csrf_token)
    User.pages_worker(user_id, fb_token, csrf_token)
  end
end
