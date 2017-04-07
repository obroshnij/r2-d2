class Legal::CfcRequest::SubmitForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :submitted_by_id,              Integer
  attribute :nc_username,                  String
  attribute :signup_date,                  Date
  attribute :request_type,                 String
  attribute :find_relations_reason,        String
  attribute :reference,                    String
  attribute :service_type,                 String
  attribute :domain_name,                  String
  attribute :service_id,                   String
  attribute :pe_subscription,              String
  attribute :abuse_type,                   String
  attribute :other_description,            String
  attribute :service_status,               String
  attribute :service_status_reference,     String
  attribute :comments,                     String
  attribute :log_comments,                 String
  attribute :investigation_approved_by_id, Integer
  attribute :investigate_unless_fraud,     Boolean
  attribute :certainty_threshold,          Integer

  validates :submitted_by_id,              presence: true
  validates :nc_username,                  presence: true
  validates :signup_date,                  presence: true
  validates :reference,                    presence: true
  validates :domain_name,                  presence: true, host_name: true, if: :domain?
  validates :service_id,                   presence: true, if: :hosting?
  validates :pe_subscription,              presence: true, if: :private_email?
  validates :other_description,            presence: true, if: :other_abuse?
  validates :service_status_reference,     presence: true, if: :service_inactive?
  validates :log_comments,                 presence: true, if: :log_comments_required?
  validates :investigation_approved_by_id, presence: true, if: :investigation_approved_by_id_required?
  validates :certainty_threshold,          presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }, if: :certainty_threshold_required?

  validate  :signup_date_format

  def initialize id = nil, ability
    @cfc_request = id ? Legal::CfcRequest.find(id) : Legal::CfcRequest.new
    @ability = ability
  end

  def signup_date_format
    return if signup_date.is_a?(Date)
    errors.add :signup_date, 'is invalid'
  end

  def domain?
    service_type == "domain"
  end

  def hosting?
    service_type == "hosting"
  end

  def private_email?
    service_type == "private_email"
  end

  def other_abuse?
    abuse_type == "other_abuse"
  end

  def service_inactive?
    service_status == "cancelled" || service_status == "suspended"
  end

  def check_for_fraud?
    request_type == 'check_for_fraud'
  end

  def find_relations?
    request_type == 'find_relations'
  end

  def log_comments_required?
    model.persisted?
  end

  def investigation_approved_by_id_required?
    return false if ability.can?(:request_relations_without_agreement, model)

    check_for_fraud? && investigate_unless_fraud ||
      find_relations? && find_relations_reason == 'internal_investigation'
  end

  def certainty_threshold_required?
    find_relations? || check_for_fraud? && investigate_unless_fraud
  end

  def model
    @cfc_request
  end

  def submit params
    self.attributes = params
    return false unless valid?
    persist!
    true
  end

  private

  attr_reader :ability

  def persist!
    model.assign_attributes request_attrs
    model.status = :_new
    model.submitted_by_id ||= submitted_by_id
    model.logs.build log_attrs
    model.save!
  end

  def log_attrs
    {
      user_id: submitted_by_id,
      action:  model.persisted? ? 'edited' : 'submitted',
      comment: log_comments
    }
  end

  def request_attrs
    attributes.except(:submitted_by_id, :log_comments)
  end

end
