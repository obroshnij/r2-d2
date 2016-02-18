class Legal::HostingAbuse::Resource::ActivityTypeAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_activity_type_assignments'
  
  belongs_to :resource,      class_name: 'Legal::HostingAbuse::Resource',               foreign_key: 'resource_id'
  belongs_to :activity_type, class_name: 'Legal::HostingAbuse::Resource::ActivityType', foreign_key: 'activity_type_id' 
end