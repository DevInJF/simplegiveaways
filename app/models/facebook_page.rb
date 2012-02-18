# -*- encoding : utf-8 -*-
class FacebookPage < ActiveRecord::Base

  has_many :giveaways
  has_and_belongs_to_many :users

  # Ensure that only one giveaway can run on a FacebookPage at a time
  # Deal with case where FacebookPage already exists and new user is adding it again
  # validates :pid, :uniqueness => {:scope => [:kind, :user]}
  
  def retrieve_fb_meta
    graph = Koala::Facebook::API.new(token)
    fb_page = graph.get_object("me")

    self.avatar = fb_page["picture"]
    self.description = fb_page["description"]
    self.url = fb_page["link"]
    self.likes = fb_page["likes"]

    self
  end
end
