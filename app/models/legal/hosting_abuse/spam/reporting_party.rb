class Legal::HostingAbuse::Spam::ReportingParty < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_reporting_parties'
  
  has_many :assignments, class_name: 'Legal::HostingAbuse::Spam::ReportingPartyAssignment', foreign_key: 'reporting_party_id'
  has_many :spam,        through: :assignments
end