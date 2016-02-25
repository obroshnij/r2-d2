class Legal::HostingAbuse::Other::AbuseType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_other_abuse_types'
  
  has_many :assignments, class_name: 'Legal::HostingAbuse::Other::AbuseTypeAssignment', foreign_key: 'abuse_type_id'
  has_many :other,       through: :assignments
end