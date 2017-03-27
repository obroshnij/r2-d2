class Legal::CfcRequest::SubmitForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :submitted_by_id,           Integer
  attribute :nc_username,               String
  attribute :signup_date,               Date
  attribute :request_type,              String
  attribute :find_relations_reason,     String
  attribute :reference,                 String
  attribute :service_type,              String
  attribute :domain_name,               String
  attribute :service_id,                String
  attribute :pe_subscription,           String
  attribute :abuse_type,                String
  attribute :other_description,         String
  attribute :service_status,            String
  attribute :service_status_reference,  String
  attribute :comments,                  String

  validates :submitted_by_id,           presence: true
  validates :nc_username,               presence: true
  validates :signup_date,               presence: true
  validates :reference,                 presence: true
  validates :domain_name,               presence: true, host_name: true, if: :domain?
  validates :service_id,                presence: true, if: :hosting?
  validates :pe_subscription,           presence: true, if: :private_email?
  validates :other_description,         presence: true, if: :other_abuse?
  validates :service_status_reference,  presence: true, if: :service_inactive?

  validate  :signup_date_format

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

  def initialize id = nil
    @cfc_request = id ? Legal::CfcRequest.find(id) : Legal::CfcRequest.new
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

  def persist!
    model.assign_attributes attributes
    model.status = :_new
    model.save!
  end

end
