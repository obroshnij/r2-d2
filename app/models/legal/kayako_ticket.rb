class Legal::KayakoTicket < ActiveRecord::Base
  self.table_name = 'legal_kayako_tickets'
  
  has_many :hosting_abuse, class_name: 'Legal::HostingAbuse', foreign_key: 'ticket_id'
  
  def hosting_abuse_count
    Legal::HostingAbuse.where(ticket_id: id).count
  end
end