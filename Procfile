# web:        bundle exec unicorn_rails -c config/unicorn.rb -E production -D
scheduler:  bundle exec rake environment resque:scheduler
worker:     QUEUE=* bundle exec rake environment resque:work