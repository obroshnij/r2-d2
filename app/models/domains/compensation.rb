class Domains::Compensation < ActiveRecord::Base
  self.table_name = 'domains_compensations'

  enum status: [:_new, :_checked]

  belongs_to :submitted_by,        class_name: 'User',                               foreign_key: 'submitted_by_id'
  belongs_to :checked_by,          class_name: 'User',                               foreign_key: 'checked_by_id'
  belongs_to :product,             class_name: 'Compensation::NamecheapProduct',     foreign_key: 'product_id'
  belongs_to :product_compensated, class_name: 'Compensation::NamecheapProduct',     foreign_key: 'product_compensated_id'
  belongs_to :service_compensated, class_name: 'Compensation::NamecheapService',     foreign_key: 'service_compensated_id'
  belongs_to :hosting_type,        class_name: 'Compensation::NamecheapHostingType', foreign_key: 'hosting_type_id'
  belongs_to :issue_level,         class_name: 'Compensation::IssueLevel',           foreign_key: 'issue_level_id'
  belongs_to :compensation_type,   class_name: 'Compensation::CompensationType',     foreign_key: 'compensation_type_id'
  belongs_to :tier_pricing,        class_name: 'Compensation::TierPricing',          foreign_key: 'tier_pricing_id'

  scope :with_data, -> { includes(
    :submitted_by, :product, :product_compensated, :service_compensated,
    :hosting_type, :issue_level, :compensation_type, :tier_pricing
  ) }

  def self.submitted_by
    User.where id: select(:submitted_by_id).distinct.pluck(:submitted_by_id)
  end

  def client_satisfied= satisfied
    satisfied = satisfied == "n/a" ? nil : satisfied
    super satisfied
  end

  def client_satisfied
    super.nil? ? "n/a" : super
  end

end
