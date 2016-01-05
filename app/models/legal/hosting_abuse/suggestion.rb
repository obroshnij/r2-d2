class Legal::HostingAbuse::Suggestion < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_suggestions'
  
  has_many :reports, class_name: 'Legal::HostingAbuse', foreign_key: 'suggestion_id'
end