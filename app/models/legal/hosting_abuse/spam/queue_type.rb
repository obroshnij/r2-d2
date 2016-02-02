class Legal::HostingAbuse::Spam::QueueType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_queue_types'
  
  has_many :assignments, class_name: 'Legal::HostingAbuse::Spam::QueueTypeAssignment', foreign_key: 'queue_type_id'
  has_many :spam,        through: :assignments
end