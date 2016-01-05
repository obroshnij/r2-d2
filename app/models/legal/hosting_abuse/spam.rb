class Legal::HostingAbuse::Spam < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam'
  
  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'
  
  belongs_to :detection_method, class_name: 'Legal::HostingAbuse::Spam::DetectionMethod', foreign_key: 'detection_method_id'
  belongs_to :queue_type,       class_name: 'Legal::HostingAbuse::Spam::QueueType',       foreign_key: 'queue_type_id'
  belongs_to :reporting_party,  class_name: 'Legal::HostingAbuse::Spam::ReportingParty',  foreign_key: 'reporting_party_id'
end