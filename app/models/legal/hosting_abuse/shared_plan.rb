class Legal::HostingAbuse::SharedPlan < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_shared_plans'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'shared_plan_id'
end