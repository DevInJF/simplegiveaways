Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '224405887571151', 'da7dc60be4b02073a6b584722896e6c9'
end