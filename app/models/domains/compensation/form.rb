class Domains::Compensation::Form

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :submitted_by_id,        Integer
  attribute :checked_by_id,          Integer
  attribute :status,                 String
  attribute :reference_id,           String
  attribute :reference_item,         String
  attribute :affected_product_id,    Integer
  attribute :product_compensated_id, Integer
  attribute :service_compensated_id, Integer
  attribute :hosting_type_id,        Integer
  attribute :issue_level_id,         Integer
  attribute :compensation_type_id,   Integer
  attribute :discount_recurring,     Boolean
  attribute :compensation_amount,    Float
  attribute :tier_pricing_id,        Integer
  attribute :client_satisfied,       Boolean
  attribute :comments,               String
  attribute :qa_comments,            String
  attribute :used_correctly,         Boolean
  attribute :delivered,              Boolean
  attribute :created_at,             DateTime
  attribute :checked_at,             DateTime

  validates :reference_id,           presence: true
  validates :service_compensated_id, presence: true,     if: :service_compensated_required?
  validates :compensation_amount,    presence: true,     if: :compensation_amount_required?
  validates :compensation_amount,    numericality: true, if: :compensation_amount_required?
  validates :tier_pricing_id,        presence: true,     if: :tier_pricing_required?

  def initialize compensation_id = nil, current_user, log_action
    @compensation = if compensation_id.present?
      Domains::Compensation.find compensation_id
    else
      Domains::Compensation.new
    end
    @current_user = current_user
    @log_action = log_action
  end

  def service_compensated_required?
    ![5, 6, 8, 12].include?(product_compensated_id)
  end

  def compensation_amount_required?
    compensation_type_id != 7
  end

  def tier_pricing_required?
    compensation_type_id == 7
  end

  def model
    @compensation
  end

  def submit params
    self.attributes = params
    format_attributes
    return false unless valid?
    persist!
    true
  end

  private

  def persist!
    @compensation.assign_attributes attributes
    @compensation.department = get_department
    if @compensation.persisted?
      @compensation.logs.build(user_id: @current_user.id, action: @log_action)
    end
    @compensation.save!
  end

  def format_attributes
    format_compensation_amount
    format_created_at
    format_checked_at
  end

  def format_compensation_amount
    if compensation_amount.present? && compensation_amount.is_a?(String)
      self.compensation_amount = compensation_amount.gsub(',', '.')
    end
  end

  def format_created_at
    self.created_at ||= Time.zone.now
  end

  def format_checked_at
    return unless @compensation.checked_at.blank? && status == "_checked"
    self.checked_at = Time.zone.now
  end

  def get_department
    groups = User.find(submitted_by_id).groups.pluck(:name)
    return "Hosting"    if groups.any? { |g| g =~ /cs-hosting/ }
    return "Billing"    if groups.any? { |g| g =~ /cs-billing/ }
    return "SSL"        if groups.any? { |g| g =~ /cs-ssl/ }
    return "Concierge"  if groups.any? { |g| g =~ /cs-concierge/ }
    return "Domains"    if groups.any? { |g| g =~ /cs-domain/ }
    return "Operations" if groups.any? { |g| g =~ /cs-operations/ }
    return "RM CFC"     if groups.any? { |g| g =~ /rm-cfc/ }
    return "RM L&A"     if groups.any? { |g| g =~ /rm-la/ }
    return "RM NBI"     if groups.any? { |g| g =~ /rm-nbi/ }
    "Other"
  end

end
