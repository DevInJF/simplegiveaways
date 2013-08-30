if Rails.env.production?
  SG_DOMAIN = 'simplegiveaways.herokuapp.com'
else
  SG_DOMAIN = '0.0.0.0:8000'
end
