class Legal::HostingAbuse::Ddos::BlockType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_ddos_block_types'
  
  has_many :ddos, class_name: 'Legal::HostingAbuse::Ddos', foreign_key: 'block_type_id'
end