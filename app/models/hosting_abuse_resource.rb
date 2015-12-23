class HostingAbuseResource < ActiveRecord::Base
  
  enum resource_abuse_type: [:cron_job, :disc_space, :lve_mysql]
  
  enum activity_type:       [:too_many, :too_often]
  enum measure:             [:frequency_reduced, :amount_reduced, :other]
  
  enum upgrade_suggestion:  [:business_ssd, :vps_one, :vps_two, :vps_three, :dedicated]
  enum impact:              [:medium, :high, :extremely_high]
  
end