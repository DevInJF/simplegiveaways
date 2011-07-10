class WelcomeController < ApplicationController
  
  respond_to :html, :xml, :json
  
  def index
    @authentications = current_user.authentications if current_user
  end
end