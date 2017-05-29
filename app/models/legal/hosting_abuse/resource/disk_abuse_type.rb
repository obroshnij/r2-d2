class Legal::HostingAbuse::Resource::DiskAbuseType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_disk_abuse_types'

  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'disk_abuse_type_id'
end
