class Legal::HostingAbuse::ResellerPlan < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_reseller_plans'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'reseller_plan_id'
end