class Domains::Compensation::Log < ActiveRecord::Base
  self.table_name = 'domains_compensation_logs'

  belongs_to :compensation, class_name: 'Domains::Compensation', foreign_key: 'compensation_id', inverse_of: 'logs'
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  before_create :get_compensation_changes

  private

  def get_compensation_changes
    self.payload = compensation_changes.each_with_object({}) do |pair, hash|
      key, vals = pair
      hash[format_attr_name(key)] = format_attr_vals(key, vals)
    end
  end

  def compensation_changes
    compensation.changes.except(
      'id',
      'status',
      'created_at',
      'updated_at',
      'submitted_by_id',
      'checked_by_id',
      'checked_at'
    )
  end

  def format_attr_name key
    key.humanize
  end

  def format_attr_vals key, vals
    relation_method = key =~ /_id$/ && key.gsub(/_id$/, "")

    if relation_method && compensation.respond_to?(relation_method)
      return vals.compact.map { |v| compensation.send(relation_method).class.find(v).name }
    end

    vals.map { |v| format_single_val(v) }.compact
  end

  def format_single_val val
    return "Yes"  if val == true
    return "No"   if val == false
    val
  end

end
