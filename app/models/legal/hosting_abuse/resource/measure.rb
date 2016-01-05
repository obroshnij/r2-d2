class Legal::HostingAbuse::Resource::Measure < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_measures'
  
  has_many :resource, class_name: 'Legal::HostingAbuse::Resource', foreign_key: 'measure_id'
end