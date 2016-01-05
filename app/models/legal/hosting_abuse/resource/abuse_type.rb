class Legal::HostingAbuse::Resource::AbuseType
  self.table_name = 'legal_hosting_abuse_resource_abuse_types'
  
  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'abuse_type_id'
end