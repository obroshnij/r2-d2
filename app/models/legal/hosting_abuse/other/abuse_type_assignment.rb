class Legal::HostingAbuse::Other::AbuseTypeAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_other_abuse_type_assignments'
  
  belongs_to :other,      class_name: 'Legal::HostingAbuse::Other',            foreign_key: 'other_id'
  belongs_to :abuse_type, class_name: 'Legal::HostingAbuse::Other::AbuseType', foreign_key: 'abuse_type_id'
end