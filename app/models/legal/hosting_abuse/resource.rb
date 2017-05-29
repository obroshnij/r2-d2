class Legal::HostingAbuse::Resource < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource'

  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'

  belongs_to :impact,                    class_name: 'Legal::HostingAbuse::Resource::Impact',                 foreign_key: 'impact_id'
  belongs_to :type,                      class_name: 'Legal::HostingAbuse::Resource::ResourceType',           foreign_key: 'type_id'
  belongs_to :upgrade,                   class_name: 'Legal::HostingAbuse::Resource::Upgrade',                foreign_key: 'upgrade_id'
  belongs_to :disk_abuse_type,           class_name: 'Legal::HostingAbuse::Resource::DiskAbuseType',          foreign_key: 'disk_abuse_type_id'

  has_many   :assignments,               class_name: 'Legal::HostingAbuse::Resource::AbuseTypeAssignment',    foreign_key: 'resource_id'
  has_many   :abuse_types,               through: :assignments

  has_many   :activity_type_assignments, class_name: 'Legal::HostingAbuse::Resource::ActivityTypeAssignment', foreign_key: 'resource_id'
  has_many   :activity_types,            through: :activity_type_assignments

  has_many   :measure_assignments,       class_name: 'Legal::HostingAbuse::Resource::MeasureAssignment',      foreign_key: 'resource_id'
  has_many   :measures,                  through: :measure_assignments
end
