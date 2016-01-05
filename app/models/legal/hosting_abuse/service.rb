class Legal::HostingAbuse::Service < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_services'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'service_id'
end