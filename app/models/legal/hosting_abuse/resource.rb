class Legal::HostingAbuse::Resource < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource'
  
  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'
  
  belongs_to :abuse_type,    class_name: 'Legal::HostingAbuse::Resource::AbuseType',    foreign_key: 'abuse_type_id'
  belongs_to :activity_type, class_name: 'Legal::HostingAbuse::Resource::ActivityType', foreign_key: 'activity_type_id'
  belongs_to :impact,        class_name: 'Legal::HostingAbuse::Resource::Impact',       foreign_key: 'impact_id'
  belongs_to :measure,       class_name: 'Legal::HostingAbuse::Resource::Measure',      foreign_key: 'measure_id'
  belongs_to :type,          class_name: 'Legal::HostingAbuse::Resource::ResourceType', foreign_key: 'type_id'
  belongs_to :upgrade,       class_name: 'Legal::HostingAbuse::Resource::Upgrade',      foreign_key: 'upgrade_id'
end