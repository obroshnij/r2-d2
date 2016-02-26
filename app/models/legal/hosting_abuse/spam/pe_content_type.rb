class Legal::HostingAbuse::Spam::PeContentType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_pe_content_types'
  
  has_many :pe_spam, class_name: 'Legal::HostingAbuse::PeSpam', foreign_key: 'pe_content_type_id'
end