# Load the rails application
require File.expand_path('../application', __FILE__)

# Facebook Credentials
FB_APP_ID = "224405887571151"
FB_APP_SECRET = "da7dc60be4b02073a6b584722896e6c9"
FB_APP_KEY = "224405887571151|8ab46e88ad218a3a931cb065.0-808283|7q2vOLeyTEVZ931hBO3yHL0IKZc"

# Initialize the rails application
SGA::Application.initialize! do |config|
  config.gem "jammit"
end
