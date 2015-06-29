require 'resque'

Resque.redis = 'localhost:6379'
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }

require 'resque-scheduler'
require 'resque/scheduler/server'