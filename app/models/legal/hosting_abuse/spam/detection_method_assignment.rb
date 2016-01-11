class Legal::HostingAbuse::Spam::DetectionMethodAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_detection_method_assignments'
  
  belongs_to :spam,             class_name: 'Legal::HostingAbuse::Spam',                  foreign_key: 'spam_id'
  belongs_to :detection_method, class_name: 'Legal::HostingAbuse::Spam::DetectionMethod', foreign_key: 'detection_method_id'
end