class DnsDdosForm
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  # Abuse Report attributes
  attribute :reported_by,              Integer
  attribute :processed_by,             Integer
  attribute :processed,                Boolean
  attribute :comment,                  String
  # Ddos Info attributes
  attribute :registered_domains,       Integer
  attribute :free_dns_domains,         Integer
  attribute :cfc_status,               Boolean
  attribute :cfc_comment,              String
  attribute :amount_spent,             Float
  attribute :last_signed_in_on_string, String
  attribute :vendor_ticket_id,         String
  attribute :client_ticket_id,         String
  attribute :impact,                   String
  attribute :target_service,           String
  attribute :random_domains,           Boolean
  # Report Assignments (direct) attributes
  attribute :username,                 String
  attribute :signed_up_on_string,      String
  attribute :target_domains,           String
  
  def initialize(report_id = nil)
    init_model report_id
    assign_model_attributes
  end
  
  def init_model(report_id)
    if report_id.present?
      @abuse_report = AbuseReport.find report_id
    else
      @abuse_report = AbuseReport.new abuse_report_type_id: 2
      @abuse_report.ddos_info = DdosInfo.new
      direct_assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 1
      direct_assignment.reportable = NcUser.new
      @abuse_report.report_assignments << direct_assignment
    end
  end
  
  def assign_model_attributes
    self.attributes = @abuse_report.attributes.merge @abuse_report.ddos_info.attributes
    @direct_assignment = @abuse_report.report_assignments.find { |a| a.report_assignment_type_id == 1 }
    self.username = @direct_assignment.reportable.username
    self.signed_up_on_string = @direct_assignment.reportable.signed_up_on_string
  end
  
  def target_domains
    @abuse_report.report_assignments.select do |a|
      a.report_assignment_type_id == 1 && a.reportable_type == 'NcService'
    end.map(&:reportable).map(&:name).join(', ')
  end
  
  def target_domains=(domains)
    @abuse_report.report_assignments.select do |a|
      a.report_assignment_type_id == 1 && a.reportable_type == 'NcService'
    end.destroy_all
    DomainName.parse_multiple(domains).map(&:name).each do |name|
      assignment = ReportAssignment.create reportable_type: 'NcService', report_assignment_type_id: 1
      assignment.reportable = NcService.find_or_create_by(nc_service_type_id: 1, name: name)
      @abuse_report.report_assignments << assignment
    end
  end
  
  def persisted?
    @abuse_report.persisted?
  end
  
  def submit(params)
    self.attributes = params[:dns_ddos_form]
    return false unless valid?
    persist!
    true
  end
  
  private
  
  def persist!
    @abuse_report.assign_attributes abuse_report_params
    @abuse_report.ddos_info.assign_attributes ddos_info_params
    @direct_assignment.reportable = NcUser.find_or_create_by(username: self.username.downcase.strip)
    @direct_assignment.reportable.signed_up_on_string = self.signed_up_on_string
    @abuse_report.save!
  end
  
  def abuse_report_params
    self.attributes.slice(:reported_by, :processed_by, :processed, :comment)
  end
  
  def ddos_info_params
    self.attributes.slice(:registered_domains, :free_dns_domains, :cfc_status, :cfc_comment, :amount_spent, :last_signed_in_on_string,
                          :vendor_ticket_id, :client_ticket_id, :impact, :target_service, :random_domains)
  end
  
end