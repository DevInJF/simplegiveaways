# -*- encoding : utf-8 -*-
class FacebookPage < ActiveRecord::Base

  has_many :giveaways
  has_and_belongs_to_many :users

  validates :pid, :uniqueness => true

  def self.retrieve_fb_meta(user, pages)
    [pages].compact.flatten.each do |page|
      unless page["category"] == "Application"
        @graph = Koala::Facebook::API.new(page["access_token"])

        batch_data = @graph.batch do |batch_api|
          batch_api.get_object("me")
          batch_api.get_picture("me", :type => "square")
        end

        fb_meta = batch_data[0]
        fb_avatar = batch_data[1]

        if fb_meta["link"].include? "facebook.com"

          @page = FacebookPage.find_or_create_by_pid(page["id"])
          @page.update_attributes(
            :name => page["name"],
            :category => page["category"],
            :pid => page["id"],
            :token => page["access_token"],
            :avatar => fb_avatar,
            :description => fb_meta["description"],
            :url => fb_meta["link"],
            :likes => fb_meta["likes"],
            :has_added_app => fb_meta["has_added_app"]
          )

          unless user.facebook_pages.include? @page
            user.facebook_pages << @page
          end
        end
      end
    end
  end
end
