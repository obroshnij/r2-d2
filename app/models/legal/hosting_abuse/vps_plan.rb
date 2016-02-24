class Legal::HostingAbuse::VpsPlan < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_vps_plans'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'vps_plan_id'
end