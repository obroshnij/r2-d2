class HostingAbuseInfo < ActiveRecord::Base
  
  enum hosting_service:    [:shared, :reseller, :vps, :dedicated, :pe]  
  enum hosting_abuse_type: [:spam, :ip_feedback, :lve_mysql, :disc_space, :cron_job, :ddos]
  enum management_type:    [:not_managed, :partially_managed, :fully_managed]
  enum package:            [:value, :business, :professional, :ultimate]
  enum suggestion:         [:six, :twelve, :twenty_four, :to_suspend, :suspended]
  
end