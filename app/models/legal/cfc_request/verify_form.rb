class Legal::CfcRequest::VerifyForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :processed_by_id,        Integer
  attribute :verification_ticket_id, String

  validates :processed_by_id,        presence: true
  validates :verification_ticket_id, presence: true

  def initialize id
    @cfc_request = Legal::CfcRequest.find id
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
    model.processed_at = Time.zone.now
    model.status = :_pending
    model.save!
  end

end
