class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_many :transactions
  has_and_belongs_to_many :facebook_pages

  devise :database_authenticatable, :registerable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def apply_omniauth(omniauth)
    case omniauth['provider']
    when 'facebook'
      apply_facebook(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def generate_account
    retrieve_pages
  end
  handle_asynchronously :generate_account


  protected

  def apply_facebook(omniauth)
    if omniauth
      self.email = omniauth['info']['email'] rescue ''
      self.name = omniauth['info']['name'] rescue ''
    end
  end

  def retrieve_pages
    graph = Koala::Facebook::GraphAPI.new(authentications.last.token)
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
end