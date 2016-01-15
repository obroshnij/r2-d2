class Legal::HostingAbuse::Resource < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource'
  
  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'
  
  belongs_to :impact,        class_name: 'Legal::HostingAbuse::Resource::Impact',       foreign_key: 'impact_id'
  belongs_to :type,          class_name: 'Legal::HostingAbuse::Resource::ResourceType', foreign_key: 'type_id'
  belongs_to :upgrade,       class_name: 'Legal::HostingAbuse::Resource::Upgrade',      foreign_key: 'upgrade_id'
  
  has_many  :assignments,    class_name: 'Legal::HostingAbuse::Resource::AbuseTypeAssignment', foreign_key: 'resource_id'
  has_many  :abuse_types,    through: :assignments
end