class Legal::HostingAbuse::Spam::QueueTypeAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_queue_type_assignments'
  
  belongs_to :spam,            class_name: 'Legal::HostingAbuse::Spam',                 foreign_key: 'spam_id'
  belongs_to :queue_type,      class_name: 'Legal::HostingAbuse::Spam::QueueType',      foreign_key: 'queue_type_id'
end