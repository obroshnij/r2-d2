class Legal::HostingAbuse::Resource::ResourceType
  self.table_name = 'legal_hosting_abuse_resource_types'
  
  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'type_id'
end