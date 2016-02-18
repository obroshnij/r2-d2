class Legal::HostingAbuse::Resource::MeasureAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_measure_assignments'
  
  belongs_to :resource, class_name: 'Legal::HostingAbuse::Resource',          foreign_key: 'resource_id'
  belongs_to :measure,  class_name: 'Legal::HostingAbuse::Resource::Measure', foreign_key: 'measure_id' 
end