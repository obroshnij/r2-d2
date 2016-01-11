class Legal::HostingAbuse::Resource::AbuseType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_abuse_types'
  
  has_many :assignments, class_name: 'Legal::HostingAbuse::Resource::AbuseTypeAssignment', foreign_key: 'abuse_type_id'
  has_many :resource,    through: :assignments
end