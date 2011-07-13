class Authentication < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  
  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end
end