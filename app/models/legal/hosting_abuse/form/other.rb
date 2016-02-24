class Legal::HostingAbuse::Form::Other
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :shared_plan_id, :service_id
  
  attribute :abuse_type_ids,    Array[Integer]
  attribute :domain_name,       String
  attribute :url,               String
  attribute :logs,              String
  
  validates :abuse_type_ids,    presence: { message: 'at least one must be checked' }
  validates :domain_name,       presence: true, host_name: true
  
  validate  :url_or_logs_must_be_present
  
  def name
    'other'
  end
  
  def url_or_logs_must_be_present
    if url.blank? && logs.blank?
      errors.add :url,  "both URL and Log can't be blank"
      errors.add :logs, "both URL and Log can't be blank"
    end
  end
  
  def abuse_type_ids= ids
    super ids.present? ? ids.delete_if(&:blank?) : []
  end
  
  def persist hosting_abuse
    hosting_abuse.other ||= Legal::HostingAbuse::Other.new
    hosting_abuse.other.assign_attributes other_params
  end
  
  private
  
  def other_params
    attr_names = Legal::HostingAbuse::Other.attribute_names.map(&:to_sym) + [:abuse_type_ids]
    self.attributes.slice(*attr_names).delete_if { |key, val| val.nil? }
  end
end