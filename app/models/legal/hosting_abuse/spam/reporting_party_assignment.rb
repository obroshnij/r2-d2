class Legal::HostingAbuse::Spam::ReportingPartyAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_reporting_party_assignments'
  
  belongs_to :spam,            class_name: 'Legal::HostingAbuse::Spam',                 foreign_key: 'spam_id'
  belongs_to :reporting_party, class_name: 'Legal::HostingAbuse::Spam::ReportingParty', foreign_key: 'reporting_party_id' 
end