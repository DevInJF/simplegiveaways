# -*- encoding : utf-8 -*-
class FacebookPage < ActiveRecord::Base

  has_many :giveaways
  has_and_belongs_to_many :users

  validates :pid, :uniqueness => true

  def square_avatar
    "http://graph.facebook.com/#{pid}/picture?type=square"
  end
  
  def self.retrieve_fb_meta(user, pages)
    [pages].compact.flatten.each do |page|
      unless page["category"] == "Application"
        graph = Koala::Facebook::API.new(page["access_token"])
        fb_meta = graph.get_object("me")

        if fb_meta["link"].include? "facebook.com"

          @page = FacebookPage.find_or_create_by_pid(page["id"])
          @page.update_attributes(
            :name => page["name"],
            :category => page["category"],
            :pid => page["id"],
            :token => page["access_token"],
            :avatar => fb_meta["picture"],
            :description => fb_meta["description"],
            :url => fb_meta["link"],
            :likes => fb_meta["likes"]
          )

          unless user.facebook_pages.include? @page
            user.facebook_pages << @page
          end
        end
      end
    end
  end
end
