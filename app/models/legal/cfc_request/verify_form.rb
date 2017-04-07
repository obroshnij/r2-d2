class Legal::CfcRequest::VerifyForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :verified_by_id,         Integer
  attribute :verification_ticket_id, String
  attribute :log_comments,           String

  validates :verified_by_id,         presence: true
  validates :verification_ticket_id, presence: true
  validates :log_comments,           presence: true, if: :log_comments_required?

  def initialize id
    @cfc_request = Legal::CfcRequest.find id
  end

  def model
    @cfc_request
  end

  def log_comments_required?
    model.status == '_pending'
  end

  def submit params
    self.attributes = params
    return false unless valid?
    persist!
    true
  end

  private

  def persist!
    model.assign_attributes request_attrs
    model.verified_by_id ||= verified_by_id
    model.verified_at ||= Time.zone.now
    model.status = :_pending
    model.logs.build log_attrs
    model.save!
  end

  def request_attrs
    attributes.except(:verified_by_id, :log_comments)
  end

  def log_attrs
    {
      user_id: verified_by_id,
      action:  model.changes['status'] ? 'verification initiated' : 'verification info edited',
      comment: log_comments
    }
  end

end
