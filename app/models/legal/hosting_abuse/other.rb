class Legal::HostingAbuse::Other < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_other'
  
  belongs_to :report,       class_name: 'Legal::HostingAbuse',                             foreign_key: 'report_id'
  
  has_many   :assignments,  class_name: 'Legal::HostingAbuse::Other::AbuseTypeAssignment', foreign_key: 'other_id'
  has_many   :abuse_types,  through: :assignments
end