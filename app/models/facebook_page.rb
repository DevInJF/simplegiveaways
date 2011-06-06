class FacebookPage < ActiveRecord::Base
  belongs_to :user
  has_many :giveaways, :dependent => :destroy
  
  validates_uniqueness_of :pid, :scope => :user_id
  
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