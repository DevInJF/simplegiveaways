source 'https://rubygems.org'

gem 'rails', '3.2.8'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production, :development, :test do
  gem 'mysql2', '>= 0.3.11'
  gem 'jquery-rails'
  gem 'bootstrap-sass', '>= 2.1.0.0'
  gem 'hominid', '>= 3.0.5'
  gem 'omniauth', '>= 1.1.1'
  gem 'omniauth-facebook'
  gem 'cancan', '>= 1.6.8'
  gem 'rolify', '>= 3.2.0'
  gem 'simple_form', '>= 2.0.4'
  gem 'heroku'
  gem 'foreman'
  gem 'koala'
end

group :development, :test do
  gem 'thin', '>= 1.5.0'
  gem 'rspec-rails', '>= 2.11.0'
  gem 'factory_girl_rails', '>= 4.1.0'
  gem 'jasminerice'
end

group :production do
  gem 'unicorn', '>= 4.3.1'
end

group :development do
  gem 'haml', '>= 3.1.7'
  gem 'haml-rails', '>= 0.3.5'
  gem 'ruby_parser', '>= 2.3.1'
  gem 'hpricot', '>= 0.8.6'
  gem 'quiet_assets', '>= 1.0.1'
end

group :test do
  gem 'email_spec', '>= 1.2.1'
  gem 'capybara', '>= 1.1.2'
end