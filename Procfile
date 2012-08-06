redis: redis-server
web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: bundle exec juggernaut
sidekiq: bundle exec sidekiq -e $RACK_ENV