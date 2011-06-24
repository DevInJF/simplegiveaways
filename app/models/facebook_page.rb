class FacebookPage < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :giveaways
  
  # validates :pid, :uniqueness => {:scope => [:kind, :user]}
  
  def self.retrieve_meta(user)  
    pages = user.facebook_pages
    pages.each do |page|
      token = page.token
      graph = Koala::Facebook::GraphAPI.new(token)
      
      avatar = graph.get_picture("me")
      object = graph.get_object("me")
      
      description = object["description"]
      likes = object["likes"].to_i
      
      page.update_attributes(
        :avatar => avatar,
        :description => description,
        :likes => likes
      )
    end
  end
end