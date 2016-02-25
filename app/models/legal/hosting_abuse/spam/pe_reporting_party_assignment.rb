class Legal::HostingAbuse::Spam::PeReportingPartyAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_pe_reporting_party_assignments'
  
  belongs_to :pe_spam,         class_name: 'Legal::HostingAbuse::PeSpam',               foreign_key: 'pe_spam_id'
  belongs_to :reporting_party, class_name: 'Legal::HostingAbuse::Spam::ReportingParty', foreign_key: 'reporting_party_id' 
end