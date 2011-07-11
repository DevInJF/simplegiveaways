class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_and_belongs_to_many :facebook_pages
  has_and_belongs_to_many :giveaways
  has_and_belongs_to_many :credit_cards

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
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
    if (extra = omniauth['extra']['user_hash'] rescue false)
      self.email = (extra['email'] rescue '')
      self.name = (extra['first_name'] rescue '') + " " + (extra['last_name'] rescue '')
    end
  end

  def retrieve_pages
    graph = Koala::Facebook::GraphAPI.new(authentications.last.token)
    pages = graph.get_connections("me", "accounts")
    pages.each do |page|
      page_category = page["category"]
      unless page_category == "Application"
        self.facebook_pages.create(
          :name => page["name"],
          :category => page_category,
          :pid => page["id"],
          :token => page["access_token"]
        )
      end
    end
    FacebookPage.retrieve_meta(self)
  end
end