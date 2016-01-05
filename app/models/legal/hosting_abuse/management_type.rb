class Legal::HostingAbuse::ManagementType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_management_types'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'management_type_id'
end