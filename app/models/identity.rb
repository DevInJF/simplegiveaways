# -*- encoding : utf-8 -*-
class Identity < ActiveRecord::Base

  attr_accessible :uid, :provider, :token, :email, :avatar, :profile_url,
                  :user_id, :location, :login_count, :logged_in_at, :auth

  has_many :audits, as: :auditable

  belongs_to :user

  validates :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }, presence: true

  attr_accessor :auth

  class << self

    def find_or_create_with_omniauth(auth)
      if identity = Identity.find_with_omniauth(auth)
        IdentityProviderWorker.perform_async(identity, auth)
      else
        identity = Identity.create_with_omniauth(auth)
      end

      identity
    end

    def find_with_omniauth(auth)
      find_by_provider_and_uid(auth['provider'], auth['uid'])
    end

    def create_with_omniauth(auth)
      identity = Identity.new(auth: auth, uid: auth['uid'], provider: auth['provider'])
      if identity.set_provider_data!
        identity.save
        identity
      else
        identity.destroy
        false
      end
    end
  end

  def create_or_login_user(auth)
    return "Logged in!" if user.present?

    self.build_user(name: auth["info"]["name"], roles: ['superadmin'])

    if user.save
      WelcomeNewUserMailer.welcome(self.email).deliver
      "Logged in!"
    else
      "Something went wrong."
    end
  end

  def add_to_existing_user(current_user)
    if user == current_user
      "Already linked that account!"
    else
      self.user = current_user
      "Successfully linked that account!"
    end
  end

  def process_login(datetime, jug_key)
    UserPagesWorker.perform_async(user, jug_key)

    self.login_count = self.login_count += 1
    self.logged_in_at = datetime
    save
  end

  def set_provider_data!
    if auth['provider'] == "facebook"
      facebook
    elsif auth['provider'] == "twitter"
      twitter
    elsif auth['provider'] == "google_oauth2"
      google
    else
      false
    end
  end

  def facebook
    self.email = auth['info']['email'] rescue nil
    self.avatar = "http://graph.facebook.com/#{uid}/picture?type=large" rescue nil
    self.profile_url = auth['extra']['raw_info']['link'] rescue nil
    self.location = auth['info']['location'] rescue nil
    self.token = auth['credentials']['token'] rescue nil
  end

  def twitter
    self.handle = auth['info']['nickname'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['info']['urls']['Twitter'] rescue nil
    self.presence_urls = auth['info']['urls']['Website'].split(/\s\S+\s|\\\S|\s/m).reject(&:blank?) rescue nil
    self.location = auth['info']['location'] rescue nil
    self.bio = auth['info']['description'] rescue nil
  end

  def google
    self.email = auth['info']['email'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['extra']['raw_info']['link'] rescue nil
    google_plus
  end

  def google_plus
    profile = Curl::Easy.perform("https://www.googleapis.com/plus/v1/people/me?access_token=#{auth['credentials']['token']}")
    profile = JSON.parse(profile.body_str)

    self.bio = profile['aboutMe'] rescue nil

    self.presence_urls = profile['urls'].reject do |url|
      url.has_key? "type"
    end.map do |url|
      url["value"]
    end rescue nil

    self.location = profile['placesLived'].select do |place|
      place.has_key?("primary") && place["primary"].to_s == "true"
    end.first["value"] rescue nil

  rescue StandardError => ex
    logger.error ex.message
    nil
  end
end
