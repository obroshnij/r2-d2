class Legal::HostingAbuse::Form
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :service_id,              Integer
  attribute :type_id,                 Integer
  attribute :server_name,             String
  attribute :shared_plan_id,          Integer
  attribute :reseller_plan_id,        Integer
  attribute :cpanel_username,         String
  attribute :username,                String
  attribute :resold_username,         String
  attribute :server_rack_label,       String
  attribute :subscription_name,       String
  attribute :management_type_id,      Integer
  
  attribute :suggestion_id,           Integer
  attribute :suspension_reason,       String
  attribute :scan_report_path,        String
  attribute :comments,                String
  
  attribute :ddos,                    Legal::HostingAbuse::Form::Ddos
  attribute :resource,                Legal::HostingAbuse::Form::Resource
  attribute :spam,                    Legal::HostingAbuse::Form::Spam
  
  validates :service_id,              presence: true
  validates :type_id,                 presence: true
  
  with_options if: :shared? do |f|
    f.validates :server_name,         presence: true
    f.validates :shared_plan_id,      presence: true
    f.validates :username,            presence: true
  end
  
  with_options if: :reseller? do |f|
    f.validates :server_name,         presence: true
    f.validates :reseller_plan_id,    presence: true
    f.validates :cpanel_username,     presence: true
    f.validates :resold_username,     presence: true
  end
  
  with_options if: :vps? do |f|
    f.validates :server_name,         presence: true
    f.validates :username,            presence: true
    f.validates :management_type_id,  presence: true
  end
  
  with_options if: :dedicated_server? do |f|
    f.validates :server_name,         presence: true
    f.validates :server_rack_label,   presence: true
    f.validates :management_type_id,  presence: true
  end
  
  with_options if: :private_email? do |f|
    f.validates :subscription_name,   presence: true
  end
  
  validates :suggestion_id,           presence: true
  validates :suspension_reason,       presence: true, if: :suspension_reason_required?
  validates :scan_report_path,        presence: true, if: :scan_report_path_required?
  
  validate :child_forms_must_be_valid
  
  def child_forms_must_be_valid
    ddos.errors.each     { |key, val| errors.add "ddos[#{key}]", val }      if ddos?            && !ddos.valid?
    resource.errors.each { |key, val| errors.add "resource[#{key}]", val }  if resource_abuse?  && !resource.valid?
    spam.errors.each     { |key, val| errors.add "spam[#{key}]", val }      if spam?            && !spam.valid?
  end
  
  def shared?
    service_id == 1
  end
  
  def reseller?
    service_id == 2
  end
  
  def vps?
    service_id == 3
  end
  
  def dedicated_server?
    service_id == 4
  end
  
  def private_email?
    service_id == 5
  end
  
  def spam?
    type_id == 1
  end
  
  def resource_abuse?
    type_id == 2
  end
  
  def ddos?
    type_id == 3
  end
  
  def suspension_reason_required?
    [1, 2, 4].include? suggestion_id
  end
    
  def scan_report_path_required?
    suggestion_id == 5
  end
    
  
  def submit params
    self.attributes = params
    puts self.attributes
    return false unless valid?
    true
  end
  
end