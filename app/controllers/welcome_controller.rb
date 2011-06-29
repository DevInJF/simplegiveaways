class WelcomeController < ApplicationController
  
  respond_to :html, :xml, :json
  
  skip_before_filter :verify_authenticity_token, :only => [:index]
  
  def index
    # Homepage
  end
end