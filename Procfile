web: bundle exec thin start -p $PORT -e $RACK_ENV
redis: redis-server
worker: bundle exec sidekiq
worker: bundle exec juggernaut