class Legal::HostingAbuse::Resource::AbuseTypeAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_abuse_type_assignments'
  
  belongs_to :resource,   class_name: 'Legal::HostingAbuse::Resource',            foreign_key: 'resource_id'
  belongs_to :abuse_type, class_name: 'Legal::HostingAbuse::Resource::AbuseType', foreign_key: 'abuse_type_id' 
end