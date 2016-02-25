class Legal::HostingAbuse::Spam::PeQueueTypeAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_pe_queue_type_assignments'
  
  belongs_to :pe_spam,         class_name: 'Legal::HostingAbuse::PeSpam',               foreign_key: 'pe_spam_id'
  belongs_to :pe_queue_type,   class_name: 'Legal::HostingAbuse::Spam::PeQueueType',    foreign_key: 'pe_queue_type_id'
end