class FbAppRequestWorker
  include Sidekiq::Worker

  def perform(request_id, signed_request)
    oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    signed_request = oauth.parse_signed_request(signed_request)

    graph = Koala::Facebook::API.new(signed_request["oauth_token"])
    graph.delete_object "#{request_id}_#{signed_request["user_id"]}"
  end
end