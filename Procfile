redis: redis-server
web: bundle exec thin -p $PORT -e $RACK_ENV -R config.ru start
juggernaut: bundle exec node node_modules/.bin/juggernaut -p $PORT -e $RACK_ENV
sidekiq: bundle exec sidekiq -e $RACK_ENV