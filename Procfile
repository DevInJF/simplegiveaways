redis: redis-server
web: bundle exec thin start -p $PORT -e $RACK_ENV
juggernaut: node node_modules/juggernaut/server.js
sidekiq: bundle exec sidekiq -e $RACK_ENV