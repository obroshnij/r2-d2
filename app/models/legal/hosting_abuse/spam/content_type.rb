class Legal::HostingAbuse::Spam::ContentType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_content_types'
  
  has_many :spam, class_name: 'Legal::HostingAbuse::Spam', foreign_key: 'content_type_id'
end