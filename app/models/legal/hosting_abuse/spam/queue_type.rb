class Legal::HostingAbuse::Spam::QueueType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_queue_types'
  
  has_many :spam, class_name: 'Legal::HostingAbuse::Spam', foreign_key: 'queue_type_id'
end