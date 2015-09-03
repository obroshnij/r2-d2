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
  # Report Assignment (direct) attributes
  attribute :username,                 String
  attribute :signed_up_on_string,      String
  
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
    init_model report_id
    assign_model_attributes
  end
  
  def init_model(report_id)
    if report_id.present?
      @abuse_report = AbuseReport.find report_id
    else
      @abuse_report = AbuseReport.new abuse_report_type_id: 1
      @abuse_report.spammer_info = SpammerInfo.new
      direct_assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 1
      direct_assignment.reportable = NcUser.new
      @abuse_report.report_assignments << direct_assignment
    end
  end
  
  def assign_model_attributes
    self.attributes = @abuse_report.attributes.merge @abuse_report.spammer_info.attributes
    @direct_assignment = @abuse_report.report_assignments.find { |a| a.report_assignment_type_id == 1 }
    self.username = @direct_assignment.reportable.username
    self.signed_up_on_string = @direct_assignment.reportable.signed_up_on_string
  end
  
  def indirect_assignments
    @abuse_report.report_assignments.indirect.each_with_object({}) do |assignment, hash|
      hash[assignment.relation_type_ids] ||= []
      hash[assignment.relation_type_ids] << assignment.reportable.username
    end.each.map do |key, value|
      InternalSpammerBlacklistAssignment.new relation_type_ids: key, usernames: value.join(', ')
    end
  end
  
  def indirect_assignments_attributes=(attributes)
    attributes.delete_if { |k, v| v[:_destroy] == '1' }
    @abuse_report.report_assignments.where(report_assignment_type_id: 2).destroy_all
    attributes.values.each do |val|
      val[:usernames].to_s.downcase.scan(/[a-z0-9]+/).uniq.each do |username|
        assignment = ReportAssignment.new reportable_type: 'NcUser', report_assignment_type_id: 2, meta_data: { relation_type_ids: val[:relation_type_ids].delete_if(&:blank?) }
        assignment.reportable = NcUser.find_or_create_by(username: username.to_s.downcase.strip)
        @abuse_report.report_assignments << assignment
      end
    end
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
  
  def persist!
    @abuse_report.assign_attributes abuse_report_params
    @abuse_report.spammer_info.assign_attributes spammer_info_params
    @direct_assignment.reportable = NcUser.find_or_create_by(username: self.username.downcase.strip)
    @direct_assignment.reportable.signed_up_on_string = self.signed_up_on_string
    @abuse_report.save!
  end
  
  def abuse_report_params
    self.attributes.slice(:reported_by, :processed, :comment)
  end
  
  def spammer_info_params
    self.attributes.slice(:registered_domains, :abused_domains, :locked_domains, :abused_locked_domains, :cfc_status, :cfc_comment,
                          :amount_spent, :last_signed_in_on_string, :responded_previously, :reference_ticket_id)
  end
  
end