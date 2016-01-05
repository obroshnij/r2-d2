class Legal::HostingAbuse::Ddos < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_ddos'
  
  belongs_to :report,     class_name: 'Legal::HostingAbuse',                  foreign_key: 'report_id'
  
  belongs_to :block_type, class_name: 'Legal::HostingAbuse::Ddos::BlockType', foreign_key: 'block_type_id'
end