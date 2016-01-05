class Legal::HostingAbuse::AbuseType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_types'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'type_id'
end