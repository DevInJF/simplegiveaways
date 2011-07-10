Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, FB_APP_ID, FB_APP_SECRET, {
    :scope => 'publish_stream, offline_access, email, manage_pages, ads_management'
  }
end