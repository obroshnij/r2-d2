class Legal::HostingAbuse::Log < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_logs'
  
  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'
  belongs_to :user
  
  default_scope { order(created_at: :desc) }
end