class AbuseNotesInfo < ActiveRecord::Base
  # Abuse Notes
  
  belongs_to :abuse_report
  
  validates :reported_by, :action, presence: true
  
  after_create do
    self.abuse_report.report_assignments.direct.select { |a| a.username.present? }.each do |assignment|
      # TODO This overrides current domain owner if the domain has already been added
      assignment.reportable.update_attributes nc_user_id: NcUser.find_by(username: assignment.username).id
    end
    self.abuse_report.nc_services.each do |domain|
      domain.new_status = ServiceStatus.find_by_name("Abused out").id
      domain.save
    end
  end
  
end