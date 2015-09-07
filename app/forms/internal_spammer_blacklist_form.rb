class InternalSpammerBlacklistForm
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  # Abuse Report attributes
  attribute :reported_by,              Integer
  attribute :processed,                Boolean
  attribute :comment,                  String
  # Spammer Info attributes
  attribute :registered_domains,       Integer
  attribute :abused_domains,           Integer
  attribute :locked_domains,           Integer
  attribute :abused_locked_domains,    Integer
  attribute :cfc_status,               Boolean
  attribute :cfc_comment,              String
  attribute :amount_spent,             Float
  attribute :last_signed_in_on_string, String
  attribute :responded_previously,     Boolean
  attribute :reference_ticket_id,      String
  # Report Assignment (direct/user) attributes
  attribute :username,                 String
  attribute :signed_up_on_string,      String
  # Report Assignments (indirect/users) attributes
  attribute :indirect_assignments,     Array[InternalSpammerBlacklistAssignment]
  
  validates :amount_spent, :registered_domains, :abused_domains, :locked_domains, :abused_locked_domains, presence: true
  validates :registered_domains, :abused_domains, :locked_domains, :abused_locked_domains, numericality: { only_integer: true }
  validates :amount_spent, numericality: true
  validates :username, :signed_up_on_string, presence: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :signed_up_on_string, format: { with: /\d{1,2}\/\d{1,2}\/\d{4}/, message: "can't be blank / is invalid" }
  validates :reference_ticket_id, presence: true, if: :responded_previously
  validates :cfc_comment, presence: true, if: :cfc_status
  
  # force client side validation
  def run_conditional(method_name_value_or_proc)
    (:responded_previously == method_name_value_or_proc) || (:cfc_status == method_name_value_or_proc) || super
  end
  
  def initialize(report_id = nil)
    init_abuse_report report_id
    init_direct_user_assignment
    init_indirect_user_assignments
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
    self.attributes = params[:internal_spammer_blacklist_form]
    return false unless valid?
    persist!
    true
  end
  
  private
  
  def init_abuse_report(report_id)
    @abuse_report = if report_id.present?
      AbuseReport.find report_id
    else
      abuse_report = AbuseReport.new abuse_report_type_id: 1
      abuse_report.spammer_info = SpammerInfo.new
      abuse_report
    end
    self.attributes = @abuse_report.attributes.merge @abuse_report.spammer_info.attributes
  end
  
  def init_direct_user_assignment
    reportable = @abuse_report.direct_user_assignments.first.try(:reportable)
    self.username            = reportable.try(:username)
    self.signed_up_on_string = reportable.try(:signed_up_on_string)
  end
  
  def init_indirect_user_assignments
    self.indirect_assignments = @abuse_report.indirect_user_assignments.each_with_object({}) do |a, h|
      h[a.relation_type_ids] ||= []
      h[a.relation_type_ids] << a.reportable.username
    end.map { |k, v| { usernames: v, relation_type_ids: k } }
    self.indirect_assignments << InternalSpammerBlacklistAssignment.new if @abuse_report.new_record?
  end
  
  def persist!
    @abuse_report.assign_attributes abuse_report_params
    @abuse_report.spammer_info.assign_attributes spammer_info_params
    cleanup_assignments
    persist_direct_user_assignment
    persist_indirect_user_assignments
    @abuse_report.save!
  end
  
  def cleanup_assignments
    @abuse_report.direct_user_assignments.first.try(:destroy)
    @abuse_report.indirect_user_assignments.each { |a| a.try(:destroy) }
  end
  
  def persist_direct_user_assignment
    assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 1
    assignment.reportable = NcUser.find_or_create_by(username: self.username)
    assignment.reportable.signed_up_on_string = self.signed_up_on_string
    @abuse_report.report_assignments << assignment
  end
  
  def persist_indirect_user_assignments
    @abuse_report.report_assignments += self.indirect_assignments.map do |a|
      a.usernames_array.map do |username|
        assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 2, relation_type_ids: a.relation_type_ids
        assignment.reportable = NcUser.find_or_create_by(username: username)
        assignment
      end
    end.flatten
  end
  
  def abuse_report_params
    self.attributes.slice(:reported_by, :processed, :comment)
  end
  
  def spammer_info_params
    self.attributes.slice(:registered_domains, :abused_domains, :locked_domains, :abused_locked_domains, :cfc_status, :cfc_comment,
                          :amount_spent, :last_signed_in_on_string, :responded_previously, :reference_ticket_id)
  end
  
end