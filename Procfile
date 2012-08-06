web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq
worker: bundle exec juggernaut
redis: redis-server