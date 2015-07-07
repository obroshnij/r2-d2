web:        bundle exec unicorn_rails -c config/unicorn.rb -E production -D
scheduler:  RAILS_ENV=production bundle exec rake environment resque:scheduler BACKGROUND=yes
worker:     RAILS_ENV=production QUEUE=* bundle exec rake environment resque:work BACKGROUND=yes