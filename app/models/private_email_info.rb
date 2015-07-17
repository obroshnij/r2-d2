class PrivateEmailInfo < ActiveRecord::Base
  
  belongs_to :abuse_report
  
  after_create do
    self.abuse_report.nc_services.first.update_attributes nc_user_id: self.abuse_report.nc_users.first.id
  end
  
end