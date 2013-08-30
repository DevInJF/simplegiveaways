web: bundle exec rails server thin start -p $PORT -e $RACK_ENV
redis: redis-server
worker: bundle exec sidekiq -e $RACK_ENV -q critical,2 -q default
