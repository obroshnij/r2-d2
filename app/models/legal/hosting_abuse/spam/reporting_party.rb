class Legal::HostingAbuse::Spam::ReportingParty < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_reporting_parties'
  
  has_many :spam, class_name: 'Legal::HostingAbuse::Spam', foreign_key: 'reporting_party_id'
end