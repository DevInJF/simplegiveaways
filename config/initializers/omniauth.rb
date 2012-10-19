Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FB_APP_ID'], ENV['FB_APP_SECRET'], scope: 'publish_stream, email, manage_pages, ads_management, read_insights', display: 'page', image_size: 'large'
end
