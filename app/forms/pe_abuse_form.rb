class PeAbuseForm
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  # Abuse Report attributes
  attribute :reported_by,         Integer
  attribute :processed_by,        Integer
  attribute :processed,           Boolean
  attribute :comment,             String
  # Private Email Info attributes
  attribute :suspended,           Boolean
  attribute :reported_by_string,  String
  attribute :warning_ticket_id,   String
  # Report Assignments (direct/private email) attributes
  attribute :name,                String
  # Report Assignments (indirect/user) attributes
  attribute :username,            String
  attribute :signed_up_on_string, String
  
  validates :username, :signed_up_on_string, :name, :reported_by_string, :warning_ticket_id, presence: true
  validates :username, format: { with: /\A[\w\d]+\z/, message: "is invalid" }
  validates :signed_up_on_string, format: { with: /\A\d{1,2}\/\d{1,2}\/\d{4}\z/, message: 'is not formatted properly' }
  
  
  def initialize(report_id = nil)
    init_abuse_report report_id
    init_indirect_user_assignment
    init_direct_service_assignment
  end
  
  def name=(name)
    super name.try(:downcase).try(:strip)
  end
  
  def username=(username)
    super username.try(:downcase).try(:strip)
  end
  
  def persisted?
    @abuse_report.persisted?
  end
  
  def submit(params)
    self.attributes = params[:pe_abuse_form]
    return false unless valid?
    persist!
    true
  end
  
  private
  
  def init_abuse_report(report_id)
    @abuse_report = if report_id.present?
      AbuseReport.find report_id
    else
      abuse_report = AbuseReport.new abuse_report_type_id: 3
      abuse_report.private_email_info = PrivateEmailInfo.new
      abuse_report
    end
    self.attributes = @abuse_report.attributes.merge @abuse_report.private_email_info.attributes.except('reported_by').merge('reported_by_string' => @abuse_report.private_email_info.reported_by)
  end
  
  def init_indirect_user_assignment
    reportable = @abuse_report.indirect_user_assignments.first.try(:reportable)
    self.username            = reportable.try(:username)
    self.signed_up_on_string = reportable.try(:signed_up_on_string)
  end
  
  def init_direct_service_assignment
    self.name = @abuse_report.direct_service_assignments.first.try(:reportable).try(:name)
  end
  
  def persist!
    @abuse_report.assign_attributes abuse_report_params
    @abuse_report.private_email_info.assign_attributes private_email_info_params
    cleanup_assignments
    persist_indirect_user_assignment
    persist_direct_service_assignment
    @abuse_report.save!
  end
  
  def cleanup_assignments
    @abuse_report.indirect_user_assignments.first.try(:destroy)
    @abuse_report.direct_service_assignments.first.try(:destroy)
  end
  
  def persist_indirect_user_assignment
    assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 2
    assignment.reportable = NcUser.find_or_create_by username: self.username
    assignment.reportable.signed_up_on_string = self.signed_up_on_string
    assignment.reportable.new_status = Status.find_by_name('PE Abuser').id
    @abuse_report.report_assignments << assignment
  end
  
  def persist_direct_service_assignment
    assignment = ReportAssignment.new reportable_type: 'NcService', report_assignment_type_id: 1
    assignment.reportable = NcService.find_or_create_by name: self.name, nc_service_type_id: 2
    assignment.reportable.nc_user_id = NcUser.find_by_username(self.username).id
    @abuse_report.report_assignments << assignment
  end
  
  def abuse_report_params
    self.attributes.slice(:reported_by, :processed_by, :processed, :comment)
  end
  
  def private_email_info_params
    self.attributes.slice(:suspended, :warning_ticket_id).merge(reported_by: self.reported_by_string)
  end
  
end