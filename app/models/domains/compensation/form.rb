class Domains::Compensation::Form

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :submitted_by_id,        Integer
  attribute :reference_id,           String
  attribute :reference_item,         String
  attribute :product_id,             Integer
  attribute :product_compensated_id, Integer
  attribute :service_compesated_id,  Integer
  attribute :hosting_type_id,        Integer
  attribute :issue_level_id,         Integer
  attribute :compensation_type_id,   Integer
  attribute :discount_reccuring,     Boolean
  attribute :period_compensated,     String
  attribute :compensation_amount,    Float
  attribute :tier_pricing_id,        Integer
  attribute :client_satisfied,       Boolean
  attribute :comments,               String

  def initialize compensation_id = nil
  end

end
