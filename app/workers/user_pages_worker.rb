class UserPagesWorker
  include Sidekiq::Worker

  def perform(user, jug_key)
    @user = User.find_by_id(user["id"])
    graph = Koala::Facebook::API.new(@user.fb_token)
    pages = graph.get_connections("me", "accounts")
    FacebookPage.retrieve_fb_meta(@user, pages, jug_key)
  end
end