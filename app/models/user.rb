# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  has_many :identities, :dependent => :destroy
  has_and_belongs_to_many :facebook_pages

  def retrieve_pages
    graph = Koala::Facebook::API.new(identities.where("provider = ?", "facebook").first.token)
    pages = graph.get_connections("me", "accounts")
    FacebookPage.retrieve_fb_meta(self, pages)
  end
  handle_asynchronously :retrieve_pages
end
