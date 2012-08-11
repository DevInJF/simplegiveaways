redis: redis-server
web: bundle exec thin -p $PORT -e $RACK_ENV -R config.ru start
jug: bundle exec juggernaut
sidekiq: bundle exec sidekiq -e $RACK_ENV