web: bundle exec thin -p $PORT -e $RACK_ENV -R config.ru start
worker: bundle exec sidekiq -e $RACK_ENV