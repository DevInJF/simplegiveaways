class AccessoryFbPage < ActiveRecord::Base
  belongs_to :giveaway

  # def retrieve_pages(user, url)
  #   token = self.authentications.last.token
  #   graph = Koala::Facebook::GraphAPI.new(token)
  #   pages = graph.get_connections("me", "accounts")
  #   pages.each do |page|
  #     page_name = page["name"]
  #     page_cat = page["category"]
  #     page_id = page["id"]
  #     page_token = page["access_token"]
  #     unless page_id.nil? or page_id.blank?
  #       self.facebook_pages.create(
  #         :kind => "primary",
  #         :name => page_name,
  #         :category => page_cat,
  #         :pid => page_id,
  #         :token => page_token
  #       )
  #     end
  #   end
  #   FacebookPage.retrieve_meta(self)
  # end
  # 
  # def self.retrieve_meta(mandatory_likes) 
  #   pages = mandatory_likes
  #   pages.each do |page|
  #     token = page.token
  #     graph = Koala::Facebook::GraphAPI.new(token)
  #     
  #     avatar = graph.get_picture("me")
  #     object = graph.get_object("me")
  #     
  #     description = object["description"]
  #     likes = object["likes"].to_i
  #     
  #     page.update_attributes(
  #       :avatar => avatar,
  #       :description => description,
  #       :likes => likes
  #     )
  #   end
  # end
end