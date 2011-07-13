class FacebookPage < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :giveaways
  
  # validates :pid, :uniqueness => {:scope => [:kind, :user]}
  
  def retrieve_fb_meta
    graph = Koala::Facebook::GraphAPI.new(token)

    fb_page = graph.get_object("me")
    fb_page_url = fb_page["link"]

    self.avatar = fb_page["picture"]
    self.description = fb_page["description"]
    self.url = fb_page_url
    self.likes = fb_page["likes"]

    self
  end
end