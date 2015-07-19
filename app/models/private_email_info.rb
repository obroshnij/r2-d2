class PrivateEmailInfo < ActiveRecord::Base
  # PE Abuse
  
  belongs_to :abuse_report
  
  validates :reported_by, :warning_ticket_id, presence: true
  
  after_create do
    self.abuse_report.nc_services.first.update_attributes nc_user_id: self.abuse_report.nc_users.first.id
  end
  
end