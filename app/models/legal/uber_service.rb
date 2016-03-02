class Legal::UberService < ActiveRecord::Base
  self.table_name = 'legal_uber_services'
  
  has_many :hosting_abuse, class_name: 'Legal::HostingAbuse', foreign_key: 'uber_service_id'
end