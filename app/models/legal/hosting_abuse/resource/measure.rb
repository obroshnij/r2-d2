class Legal::HostingAbuse::Resource::Measure < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_measures'
  
  has_many :assignments, class_name: 'Legal::HostingAbuse::Resource::MeasureAssignment', foreign_key: 'measure_id'
  has_many :resource,    through: :assignments
end