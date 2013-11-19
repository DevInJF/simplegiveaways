web: bundle exec rails server thin start -p $PORT -e $RACK_ENV
ssl: thin start --ssl -e $RACK_ENV
redis: leader --unless-port-in-use 6379 redis-server config/redis.conf
worker: bundle exec sidekiq -e $RACK_ENV -q critical,2 -q default
