class Entry < ActiveRecord::Base
  belongs_to :giveaway

  validates :email, :uniqueness => {:scope => :giveaway_id}

  def self.like_status(pid, uid)
    @rest = Koala::Facebook::RestAPI.new(FB_APP_KEY)
    status = @rest.fql_query("SELECT uid FROM page_fan WHERE uid=#{uid} AND page_id=#{pid}")
    status[0].nil? ? false : true
  end
end