class Legal::CfcRequest::ProcessForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :processed_by_id,  Integer
  attribute :frauded,          Boolean
  attribute :relations_status, String
  attribute :process_comments, String
  attribute :log_comments,     String

  validates :log_comments, presence: true, if: :log_comments_required?

  validate :child_forms_validity

  def initialize id
    @cfc_request = Legal::CfcRequest.find id
    @child_forms = []
  end

  def child_forms_validity
    child_forms.each { |form| copy_child_errors form }
  end

  def log_comments_required?
    model.status == '_processed'
  end

  def model
    @cfc_request
  end

  def submit params
    self.attributes  = params
    self.child_forms = init_child_forms params[:relations]
    return false unless valid?
    persist!
    true
  end

  private

  attr_accessor :child_forms

  def persist!
    model.assign_attributes request_attrs
    model.processed_by_id ||= processed_by_id
    model.processed_at ||= Time.zone.now
    model.status = :_processed
    model.logs.build log_attrs
    child_forms.each &:persist!
    init_investigation_if_required!
    model.save!
  end

  def request_attrs
    attributes.except(:processed_by_id, :log_comments)
  end

  def log_attrs
    {
      user_id: processed_by_id,
      action:  model.changes['status'] ? 'processed' : 'processing info edited',
      comment: log_comments
    }
  end

  def copy_child_errors form
    return if form._destroy || form.valid?

    form.errors.messages.each do |key, val|
      errors.add "relations[#{form.cid}][#{key}]", val.first
    end
  end

  def children_required?
    relations_status == 'has_relations'
  end

  def init_child_forms params
    return [] unless children_required?
    params.map do |key, val|
      val[:request_id] = model.id
      Legal::CfcRequest::RelationForm.new key, val, self
    end
  end

  def init_investigation_if_required!
    return unless model.check_for_fraud?
    return if     model.frauded
    return unless model.investigate_unless_fraud
    return unless model.changes['status']
    
    Legal::CfcRequest::InitInvestigationService.new(model).perform
  end

end
