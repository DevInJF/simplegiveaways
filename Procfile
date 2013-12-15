web: bundle exec rails server thin start -p $PORT -e $RACK_ENV
redis: bundle exec redis-server
worker: bundle exec sidekiq -e $RACK_ENV -C ./config/sidekiq.yml
