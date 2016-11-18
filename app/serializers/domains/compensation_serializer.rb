class Domains::CompensationSerializer < ApplicationSerializer

  attributes  :id, :reference_id, :reference_item, :discount_recurring, :compensation_amount,
              :client_satisfied, :comments, :status, :department, :created_at_formatted, :product_compensated_id,
              :service_compensated, :hosting_type, :issue_level, :tier_pricing, :qa_comments,
              :delivered, :used_correctly, :service_compensated_id, :submitted_by_id, :product, :product_compensated,
              :affected_product, :compensation_type, :submitted_by

  attribute :checked_by_id,   if: :can_check?
  attribute :checked_by,      if: :show_checked_by?
  attribute :used_correctly,  if: :can_check?
  attribute :delivered,       if: :can_check?
  attribute :qa_comments,     if: :can_check?

  def created_at_formatted
    object.created_at.strftime '%b/%d/%Y, %H:%M'
  end

  %w{ product product_compensated service_compensated hosting_type issue_level affected_product compensation_type tier_pricing checked_by submitted_by }.each { |method_name|
    define_method(method_name) { object.send(method_name).try(:name) }
  }

  def can_check?
    view_context.qa?(object)
  end

  def show_checked_by?
    can_check? && object.checked_by_id
  end

end
