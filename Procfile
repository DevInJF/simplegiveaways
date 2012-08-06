web: bundle exec thin start -p $PORT -e $RACK_ENV
web: bundle exec juggernaut -p 8080 -e $RACK_ENV
worker: bundle exec sidekiq -e $RACK_ENV
redis: redis-server