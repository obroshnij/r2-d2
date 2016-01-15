class Legal::HostingAbuse < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse'
  
  has_one    :ddos,            class_name: 'Legal::HostingAbuse::Ddos',           foreign_key: 'report_id'
  has_one    :resource,        class_name: 'Legal::HostingAbuse::Resource',       foreign_key: 'report_id'
  has_one    :spam,            class_name: 'Legal::HostingAbuse::Spam',           foreign_key: 'report_id'
  
  belongs_to :service,         class_name: 'Legal::HostingAbuse::Service',        foreign_key: 'service_id'
  belongs_to :type,            class_name: 'Legal::HostingAbuse::AbuseType',      foreign_key: 'type_id'
  belongs_to :management_type, class_name: 'Legal::HostingAbuse::ManagementType', foreign_key: 'management_type_id'
  belongs_to :reseller_plan,   class_name: 'Legal::HostingAbuse::ResellerPlan',   foreign_key: 'reseller_plan_id'
  belongs_to :shared_plan,     class_name: 'Legal::HostingAbuse::SharedPlan',     foreign_key: 'shared_plan_id'
  belongs_to :suggestion,      class_name: 'Legal::HostingAbuse::Suggestion',     foreign_key: 'suggestion_id'
  
  belongs_to :reported_by,     class_name: 'User',                                foreign_key: 'reported_by_id'
  belongs_to :server,          class_name: 'Legal::HostingServer',                foreign_key: 'server_id'
  
  accepts_nested_attributes_for :ddos, :resource, :spam
end