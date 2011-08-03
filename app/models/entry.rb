class Entry < ActiveRecord::Base
  belongs_to :giveaway

  validates :email, :uniqueness => {:scope => :giveaway_id}

  def self.like_status(pid, uid)
    @rest = Koala::Facebook::RestAPI.new(FB_APP_KEY)
    status = @rest.fql_query("SELECT uid FROM page_fan WHERE uid=#{uid} AND page_id=#{pid}")
    status[0].nil? ? false : true
  end

  def build_from_session(giveaway, session, has_liked, ref)
    @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    oauth_access_token = @oauth.get_token_from_session_key(session)

    graph = Koala::Facebook::GraphAPI.new(oauth_access_token)
    @profile = graph.get_object("me")

    uid = @profile["id"]

    if @entry = Entry.find_by_uid(uid)
      @entry
    else
      @entry = giveaway.entries.build(
        :uid => uid,
        :name => @profile["name"],
        :email => @profile["email"],
        :fb_url => @profile["link"],
        :datetime_entered => DateTime.now
      )

      if has_liked == true
        @entry.has_liked_primary = true
        @entry.status = "complete"
      else
        if Entry.like_status(giveaway.facebook_page.pid, uid) == false
          @entry.status = "incomplete"
          @entry.has_liked_primary = false
        else
          @entry.has_liked_primary = true
          @entry.status = "complete"
        end
      end

      if @entry.has_liked_primary && ref != "none"
        giveaway.count_conversion(ref)
      end

      @entry
    end
  end
end