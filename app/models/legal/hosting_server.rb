class Legal::HostingServer < ActiveRecord::Base
  self.table_name = 'legal_hosting_servers'
  
  has_many :abuse_reports, class_name: 'Legal::HostingAbuse', foreign_key: 'server_id'
  
  before_save do
    self.name = self.name.strip.downcase
  end
end