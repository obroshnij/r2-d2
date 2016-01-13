class Legal::HostingAbuse::Spam::DetectionMethod < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_spam_detection_methods'
  
  has_many :spam, class_name: 'Legal::HostingAbuse::Spam', foreign_key: 'detection_method_id'
end