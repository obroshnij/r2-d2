class Legal::HostingAbuse::Resource::ActivityType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_activity_types'
  
  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'activity_type_id'
end