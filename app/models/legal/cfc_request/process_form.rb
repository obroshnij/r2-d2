class Legal::CfcRequest::ProcessForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :processed_by_id,  Integer
  attribute :frauded,          Boolean
  attribute :relations_status, String

  validate :child_forms_validity

  def initialize id
    @cfc_request = Legal::CfcRequest.find id
    @child_forms = []
  end

  def child_forms_validity
    child_forms.each { |form| copy_child_errors form }
  end

  def model
    @cfc_request
  end

  def submit params
    self.attributes  = params
    self.child_forms = params[:relations].map do |key, val|
      val[:request_id] = model.id
      Legal::CfcRequest::RelationForm.new key, val
    end
    return false unless valid?
    persist!
    true
  end

  private

  attr_accessor :child_forms

  def persist!
    model.assign_attributes attributes
    model.processed_at = Time.zone.now
    model.status = :_processed
    child_forms.each &:persist!
    model.save!
  end

  def copy_child_errors form
    return if form._destroy || form.valid?

    form.errors.messages.each do |key, val|
      errors.add "relations[#{form.cid}][#{key}]", val.first
    end
  end

end
