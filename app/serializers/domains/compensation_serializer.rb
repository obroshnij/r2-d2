class Domains::CompensationSerializer < ApplicationSerializer
  attrs = Domains::Compensation.attribute_names - ['checked_by_id', 'used_correctly', 'delivered', 'qa_comments']

  attributes *attrs + [:created_at_formatted, :service_compensated, :product_compensated, :hosting_type,
                       :issue_level, :tier_pricing, :affected_product, :compensation_type, :submitted_by, :checked_at_formatted]

  attribute :checked_by_id,   if: :can_check?
  attribute :checked_by,      if: :show_checked_by?
  attribute :used_correctly,  if: :can_check?
  attribute :delivered,       if: :can_check?
  attribute :qa_comments,     if: :can_check?

  has_many :logs

  def created_at_formatted
    object.created_at.strftime '%b/%d/%Y, %H:%M'
  end

  def checked_at_formatted
    object.checked_at.try :strftime, '%b/%d/%Y, %H:%M'
  end

  %w{
    product_compensated
    service_compensated
    hosting_type
    issue_level
    affected_product
    compensation_type
    tier_pricing
    checked_by
    submitted_by
  }.each { |method_name|
    define_method(method_name) { object.send(method_name).try(:name) }
  }

  def can_check?
    view_context.qa?(object)
  end

  def show_checked_by?
    can_check? && object.checked_by_id
  end

end
