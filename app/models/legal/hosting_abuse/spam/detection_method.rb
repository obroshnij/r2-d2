class Legal::HostingAbuse::Spam::DetectionMethod < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_detection_methods'
  
  has_many   :assignments, class_name: 'Legal::HostingAbuse::Spam::DetectionMethodAssignment', foreign_key: 'detection_method_id'
  has_many   :spam,        through: :assignments
end