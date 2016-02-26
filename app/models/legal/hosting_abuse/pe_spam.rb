class Legal::HostingAbuse::PeSpam < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_pe_spam'
  
  belongs_to :report, class_name: 'Legal::HostingAbuse', foreign_key: 'report_id'
  
  belongs_to :detection_method,              class_name: 'Legal::HostingAbuse::Spam::DetectionMethod',            foreign_key: 'detection_method_id'
  belongs_to :pe_content_type,               class_name: 'Legal::HostingAbuse::Spam::PeContentType',              foreign_key: 'pe_content_type_id'
  
  has_many  :pe_queue_type_assignments,      class_name: 'Legal::HostingAbuse::Spam::PeQueueTypeAssignment',      foreign_key: 'pe_spam_id'
  has_many  :pe_queue_types,                 through: :pe_queue_type_assignments
  
  has_many  :pe_reporting_party_assignments, class_name: 'Legal::HostingAbuse::Spam::PeReportingPartyAssignment', foreign_key: 'pe_spam_id'
  has_many  :reporting_parties,              through: :pe_reporting_party_assignments
  
  def ip_is_blacklisted= blacklisted
    blacklisted = blacklisted == 'N/A' ? nil : blacklisted
    super blacklisted
  end
  
  def ip_is_blacklisted
    super.nil? ? 'N/A' : super
  end
end