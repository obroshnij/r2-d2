class Legal::HostingAbuse::Spam < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam'
  
  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'
  
  belongs_to :detection_method,  class_name: 'Legal::HostingAbuse::Spam::DetectionMethod', foreign_key: 'detection_method_id'
  belongs_to :content_type,      class_name: 'Legal::HostingAbuse::Spam::ContentType',     foreign_key: 'content_type_id'
  
  has_many  :queue_type_assignments,      class_name: 'Legal::HostingAbuse::Spam::QueueTypeAssignment',      foreign_key: 'spam_id'
  has_many  :queue_types,                 through: :queue_type_assignments
  
  has_many  :reporting_party_assignments, class_name: 'Legal::HostingAbuse::Spam::ReportingPartyAssignment', foreign_key: 'spam_id'
  has_many  :reporting_parties,           through: :reporting_party_assignments
  
  def ip_is_blacklisted= blacklisted
    blacklisted = blacklisted == 'N/A' ? nil : blacklisted
    super blacklisted
  end
  
  def ip_is_blacklisted
    super.nil? ? 'N/A' : super
  end
end