class AbuseReport < ActiveRecord::Base
  
  belongs_to :abuse_report_type
  
  has_many :report_assignments
  has_many :nc_users, through: :report_assignments, source: :reportable, source_type: 'NcUser'
  has_many :legal_nc_users, through: :report_assignments, source: :reportable
  has_many :nc_services, through: :report_assignments, source: :reportable, source_type: 'NcService'
  
  has_one :spammer_info
  has_one :ddos_info
  has_one :private_email_info
  has_one :abuse_notes_info
  
  accepts_nested_attributes_for :spammer_info, :ddos_info, :private_email_info, :abuse_notes_info, :report_assignments
  
  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }
  
  def reportable_name
    # spammer, ddos
    return self.report_assignments.where(reportable_type: 'NcUser').direct.first.reportable.username if [1, 2].include?(self.abuse_report_type_id) 
    # private email
    return self.report_assignments.direct.first.reportable.name if self.abuse_report_type_id == 3
    # abuse notes
    count = self.report_assignments.direct.count
    count.to_s + ' domain'.pluralize(count)
  end
  
  def direct_user_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcUser' && a.report_assignment_type_id == 1 }
  end
  
  def indirect_user_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcUser' && a.report_assignment_type_id == 2 }
  end
  
  def direct_service_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcService' && a.report_assignment_type_id == 1 }
  end
  
  def indirect_service_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcService' && a.report_assignment_type_id == 2 }
  end
  
  def related_reports
    self.nc_users.map(&:abuse_reports).flatten.uniq
  end
  
end