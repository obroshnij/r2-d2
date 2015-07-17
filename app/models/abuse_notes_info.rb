class AbuseNotesInfo < ActiveRecord::Base
  
  belongs_to :abuse_report
  
  after_create do
    self.abuse_report.report_assignments.direct.select { |a| a.username.present? }.each do |assignment|
      assignment.reportable.update_attributes nc_user_id: NcUser.find_by(username: assignment.username).id
    end
  end
  
end