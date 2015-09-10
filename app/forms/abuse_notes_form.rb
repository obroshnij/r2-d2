class AbuseNotesForm
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  # Abuse Report attributes
  attribute :reported_by,        Integer
  attribute :processed_by,       Integer
  attribute :processed,          Boolean
  attribute :comment,            String
  # Abuse Notes attributes
  attribute :reported_by_string, String
  attribute :action,             String
  # Assignments attributes
  attribute :assignments,        Array[AbuseNotesAssignment]
  
  validates :reported_by_string, :action, presence: true
  
  def initialize(report_id = nil)
    init_abuse_report report_id
    init_assignments
  end
  
  def assignments_attributes=(attributes)
    self.assignments = attributes.values.delete_if { |a| a['_destroy'] == 'true' }
  end
  
  def persisted?
    @abuse_report.persisted?
  end
  
  def submit(params)
    self.attributes = params[:abuse_notes_form]
    return false unless valid?
    persist!
    true
  end
  
  private
  
  def init_abuse_report(report_id)
    @abuse_report = if report_id.present?
      AbuseReport.find report_id
    else
      abuse_report = AbuseReport.new abuse_report_type_id: 4
      abuse_report.abuse_notes_info = AbuseNotesInfo.new
      abuse_report
    end
    self.attributes = @abuse_report.attributes.merge @abuse_report.abuse_notes_info.attributes.except('reported_by').merge('reported_by_string' => @abuse_report.abuse_notes_info.reported_by)
  end
  
  def init_assignments
    self.assignments = @abuse_report.direct_service_assignments.each_with_object({}) do |a, h|
      h[a.username] ||= []
      h[a.username] << a.reportable.name
    end.map { |k, v| { username: k, domains: v.to_s } }
    self.assignments << AbuseNotesAssignment.new if @abuse_report.new_record?
  end
  
  def persist!
    @abuse_report.assign_attributes abuse_report_params
    @abuse_report.abuse_notes_info.assign_attributes abuse_notes_info_params
    cleanup_assignments
    persist_assignments
    @abuse_report.save!
  end
  
  def cleanup_assignments
    @abuse_report.direct_service_assignments.each { |a| a.try(:destroy) }
    @abuse_report.indirect_user_assignments.each { |a| a.try(:destroy) }
  end
  
  def persist_assignments
    self.assignments.each do |a|
      if a.username.present?
        assignment = ReportAssignment.new report_assignment_type_id: 2, reportable_type: 'NcUser'
        assignment.reportable = NcUser.find_or_create_by username: a.username
        assignment.reportable.new_status = Status.find_by_name('Has Abuse Notes').id
        @abuse_report.report_assignments << assignment
      end
      
      a.domains_array.each do |domain|
        assignment = ReportAssignment.new report_assignment_type_id: 1, reportable_type: 'NcService', username: a.username
        assignment.reportable = NcService.find_or_create_by name: domain, nc_service_type_id: 1
        assignment.reportable.new_status = ServiceStatus.find_by_name('Abused out').id
        assignment.reportable.nc_user_id = NcUser.find_by(username: a.username).id if a.username.present?
        @abuse_report.report_assignments << assignment
      end
    end
  end
  
  def abuse_report_params
    self.attributes.slice(:reported_by, :processed_by, :processed, :comment)
  end
  
  def abuse_notes_info_params
    self.attributes.slice(:action).merge(reported_by: self.reported_by_string)
  end
  
end