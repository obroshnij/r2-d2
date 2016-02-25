class Legal::HostingAbuse::Spam::PeQueueType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_pe_spam_queue_types'
  
  has_many :assignments, class_name: 'Legal::HostingAbuse::Spam::PeQueueTypeAssignment', foreign_key: 'pe_queue_type_id'
  has_many :pe_spam,     through: :assignments
end