class FacebookPage < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :giveaways
  
  # validates :pid, :uniqueness => {:scope => [:kind, :user]}
  
  def self.retrieve_meta(user)  
    pages = user.facebook_pages
    pages.each do |page|
      graph = Koala::Facebook::GraphAPI.new(page.token)

      fb_page = graph.get_object("me")
      fb_page_url = fb_page["link"]

      unless fb_page_url.include? "facebook.com"
        return page.destroy
      end
      
      page.update_attributes(
        :avatar => fb_page["picture"],
        :description => fb_page["description"],
        :url => fb_page_url,
        :likes => fb_page["likes"]
      )
    end
  end
end