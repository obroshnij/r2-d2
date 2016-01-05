class Legal::HostingAbuse::Resource::Impact < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_impacts'
  
  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'impact_id'
end