class PrivateEmailInfo < ActiveRecord::Base
  # PE Abuse
  
  belongs_to :abuse_report
  
  validates :reported_by, :warning_ticket_id, presence: true
  
  after_create do
    # TODO This overrides current private email owner if the subscription has already been added
    self.abuse_report.nc_services.first.update_attributes nc_user_id: self.abuse_report.nc_users.first.id if self.abuse_report.nc_users.first.present?
  end
  
end