class Legal::HostingAbuse::Resource::ActivityType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_activity_types'
    
  has_many :assignments, class_name: 'Legal::HostingAbuse::Resource::ActivityTypeAssignment', foreign_key: 'activity_type_id'
  has_many :resource,    through: :assignments
end