class User < ActiveRecord::Base
  has_many :authentications
  has_many :facebook_pages
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def apply_omniauth(omniauth)
    case omniauth['provider']
    when 'facebook'
      self.apply_facebook(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end
  
  def generate_account
    self.retrieve_pages
  end


  protected

  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['user_hash'] rescue false)
      self.email = (extra['email'] rescue '')
    end
  end
  
  def retrieve_pages
    token = self.authentications.last.token
    graph = Koala::Facebook::GraphAPI.new(token)
    pages = graph.get_connections("me", "accounts")
    pages.each do |page|
      page_name = page["name"]
      page_cat = page["category"]
      page_id = page["id"]
      page_token = page["access_token"]
      unless page_id.nil? or page_id.blank?
        self.facebook_pages.build(
          :name => page_name,
          :category => page_cat,
          :pid => page_id,
          :token => page_token
        )
      end
    end
    FacebookPage.retrieve_meta(self)
  end
end