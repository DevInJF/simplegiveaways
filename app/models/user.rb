# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  has_many :identities, :dependent => :destroy
  has_and_belongs_to_many :facebook_pages


  def retrieve_pages
    graph = Koala::Facebook::API.new(identities.where("provider = ?", "facebook").first.token)
    pages = graph.get_connections("me", "accounts")
    pages.each do |page|
      page_category = page["category"]
      unless page_category == "Application"
        @page = FacebookPage.new(
          :name => page["name"],
          :category => page_category,
          :pid => page["id"],
          :token => page["access_token"]
        ).retrieve_fb_meta

        unless @page.url.include? "facebook.com"
          @page.destroy
        else
          self.facebook_pages.create(@page.attributes)
        end
      end
    end
  end
  handle_asynchronously :retrieve_pages
end
