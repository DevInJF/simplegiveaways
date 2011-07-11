class Entry < ActiveRecord::Base
  belongs_to :giveaway

  validates :email, :uniqueness => {:scope => :giveaway_id}

  def self.like_status(pid, uid)
    @rest = Koala::Facebook::RestAPI.new(FB_APP_KEY)
    status = @rest.fql_query("SELECT uid FROM page_fan WHERE uid=#{uid} AND page_id=#{pid}")
    status[0].nil? ? false : true
  end

  def build_from_session(giveaway, session)
    @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    oauth_access_token = @oauth.get_token_from_session_key(session)

    graph = Koala::Facebook::GraphAPI.new(oauth_access_token)
    @profile = graph.get_object("me")

    uid = @profile["id"]

    entry = giveaway.entries.build(
      :uid => uid,
      :name => @profile["name"],
      :email => @profile["email"],
      :fb_url => @profile["link"],
      :datetime_entered => DateTime.now
    )

    if Entry.like_status(giveaway.facebook_page.pid, uid) == false
      entry.status = "incomplete"
    else
      entry.status = "complete"
      entry.has_liked_primary = true
    end

    entry.save
    entry
  end
end