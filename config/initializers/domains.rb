if Rails.env.production?
  SG_DOMAIN = 'simplegiveaways.herokuapp.com'
  SG_SSL_DOMAIN = 'simplegiveaways.herokuapp.com'
else
  SG_DOMAIN = '0.0.0.0:8000'
  SG_SSL_DOMAIN = '0.0.0.0:3000'
end
