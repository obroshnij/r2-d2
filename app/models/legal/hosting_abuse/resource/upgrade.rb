class Legal::HostingAbuse::Resource::Upgrade
  self.table_name = 'legal_hosting_abuse_resource_upgrades'
  
  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'upgrade_id'
end