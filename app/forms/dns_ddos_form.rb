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
  # Report Assignments (direct/user) attributes
  attribute :username,                 String
  attribute :signed_up_on_string,      String
  # Report Assignments (direct/domains) attributes
  attribute :target_domains,           Array[String]
  # Report Assignments (indirect/users) attributes
  attribute :indirect_assignments,     Array[DnsDdosAssignment]
  
  validates :username, :signed_up_on_string, :amount_spent, :registered_domains, :client_ticket_id, :target_domains, presence: true
  validates :username, format: { with: /\A[\w\d]+\z/, message: "is invalid" }
  validates :amount_spent, numericality: true
  validates :registered_domains, numericality: { only_integer: true }
  validates :signed_up_on_string, format: { with: /\A\d{1,2}\/\d{1,2}\/\d{4}\z/, message: 'is not formatted properly' }
  validates :last_signed_in_on_string, format: { with: /\A\d{1,2}\/\d{1,2}\/\d{4}\z/, message: 'is not formatted properly' }, allow_blank: true
  validates :cfc_comment, presence: true, if: :cfc_status
  validates :free_dns_domains, presence: true, numericality: { only_integer: true }, if: :free_dns_ddos?
  validates :vendor_ticket_id, presence: true, if: :free_dns_ddos?
  
  # force client side validation
  def run_conditional(method_name_value_or_proc)
    (:cfc_status == method_name_value_or_proc) || (:free_dns_ddos? == method_name_value_or_proc) || super
  end
  
  def initialize(report_id = nil)
    init_abuse_report report_id
    init_direct_user_assignment
    init_indirect_user_assignments
    init_target_domains
  end
  
  def free_dns_ddos?
    self.target_service == 'FreeDNS'
  end
  
  def target_domains
    super.join(', ')
  end
  
  def target_domains=(domains)
    super DomainName.parse_multiple(domains, remove_subdomains: true).map(&:name)
  end
  
  def username=(username)
    super username.try(:downcase).try(:strip)
  end
  
  def indirect_assignments_attributes=(attributes)
    self.indirect_assignments = attributes.values
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
  
  def init_abuse_report(report_id)
    @abuse_report = if report_id.present?
      AbuseReport.find report_id
    else
      abuse_report = AbuseReport.new abuse_report_type_id: 2
      abuse_report.ddos_info = DdosInfo.new
      abuse_report
    end
    self.attributes = @abuse_report.attributes.merge @abuse_report.ddos_info.attributes
  end
  
  def init_direct_user_assignment
    reportable = @abuse_report.direct_user_assignments.first.try(:reportable)
    self.username            = reportable.try(:username)
    self.signed_up_on_string = reportable.try(:signed_up_on_string)
  end
  
  def init_indirect_user_assignments
    self.indirect_assignments = @abuse_report.indirect_user_assignments.map do |a|
      {
        username:           a.reportable.username,
        registered_domains: a.registered_domains,
        free_dns_domains:   a.free_dns_domains,
        comment:            a.comment,
        relation_type_ids:  a.relation_type_ids
      }
    end
    self.indirect_assignments << DnsDdosAssignment.new if @abuse_report.new_record?
  end
  
  def init_target_domains
    @target_domains = @abuse_report.direct_service_assignments.map { |a| a.reportable.name }
  end
  
  def persist!
    @abuse_report.assign_attributes abuse_report_params
    @abuse_report.ddos_info.assign_attributes ddos_info_params
    cleanup_assignments
    persist_direct_user_assignment
    persist_indirect_user_assignments
    persist_target_domains
    @abuse_report.save!
  end
  
  def cleanup_assignments
    @abuse_report.direct_service_assignments.each { |a| a.try(:destroy) }
    @abuse_report.direct_user_assignments.first.try(:destroy)
    @abuse_report.indirect_user_assignments.each { |a| a.try(:destroy) }
  end
  
  def persist_direct_user_assignment
    assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 1
    assignment.reportable = NcUser.find_or_create_by(username: self.username)
    assignment.reportable.signed_up_on_string = self.signed_up_on_string
    assignment.reportable.new_status = Status.find_by_name('DNS DDoSer').id
    @abuse_report.report_assignments << assignment
  end
  
  def persist_indirect_user_assignments
    @abuse_report.report_assignments += self.indirect_assignments.map do |a|
      assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 2, registered_domains: a.registered_domains,
                                        free_dns_domains: a.free_dns_domains, comment: a.comment, relation_type_ids: a.relation_type_ids
      assignment.reportable = NcUser.find_or_create_by username: a.username
      assignment.reportable.new_status = Status.find_by_name('DDoSer Related').id
      assignment
    end
  end
  
  def persist_target_domains
    @abuse_report.report_assignments += @target_domains.map do |name|
      assignment = ReportAssignment.new reportable_type: 'NcService', report_assignment_type_id: 1
      assignment.reportable = NcService.find_or_create_by name: name, nc_service_type_id: 1
      assignment.reportable.new_status = ServiceStatus.find_by_name('DDoS Related').id
      assignment.reportable.new_status = ServiceStatus.find_by_name('FreeDNS').id if self.target_service == 'FreeDNS'
      assignment.reportable.nc_user_id = NcUser.find_by_username(self.username).id
      assignment
    end
  end
  
  def abuse_report_params
    self.attributes.slice(:reported_by, :processed_by, :processed, :comment)
  end
  
  def ddos_info_params
    self.attributes.slice(:registered_domains, :free_dns_domains, :cfc_status, :cfc_comment, :amount_spent, :last_signed_in_on_string,
                          :vendor_ticket_id, :client_ticket_id, :impact, :target_service, :random_domains)
  end
  
end