web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -e $RACK_ENV
worker: bundle exec juggernaut -e $RACK_ENV
redis: redis-server