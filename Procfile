web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -q default -q mailers
scheduler: bundle exec clockwork config/clockwork.rb
