class Legal::HostingAbuse::Form
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :reported_by_id,          Integer
  attribute :processed_by_id,         Integer
  attribute :status,                  String
  attribute :processed_at,            DateTime
  attribute :service_id,              Integer
  attribute :type_id,                 Integer
  attribute :efwd_server_name,        String
  attribute :efwd_server_id,          Integer
  attribute :server_name,             String
  attribute :server_id,               Integer
  attribute :shared_plan_id,          Integer
  attribute :reseller_plan_id,        Integer
  attribute :username,                String
  attribute :resold_username,         String
  attribute :server_rack_label,       String
  attribute :subscription_name,       String
  attribute :management_type_id,      Integer
  attribute :suggestion_id,           Integer
  attribute :suspension_reason,       String
  attribute :scan_report_path,        String
  attribute :tech_comments,           String
  attribute :legal_comments,          String
  attribute :ticket_id,               String
    
  validates :service_id,              presence: true
  validates :type_id,                 presence: true
  
  with_options if: :shared? do |f|
    f.validates :type_id,             inclusion: { in: [1], message: 'is not applicable for Email Only package' }, if: :email_only?
    f.validates :server_name,         presence: true, host_name: true
    f.validates :shared_plan_id,      presence: true
    f.validates :username,            presence: true
  end
  
  with_options if: :reseller? do |f|
    f.validates :server_name,         presence: true, host_name: true
    f.validates :reseller_plan_id,    presence: true
    f.validates :username,            presence: true
    f.validates :resold_username,     presence: true
  end
  
  with_options if: :vps? do |f|
    f.validates :server_name,         presence: true, host_name: true
    f.validates :username,            presence: true, if: :full_management?
    f.validates :management_type_id,  presence: true
    f.validates :type_id,             inclusion: { in: [1, 3], message: "is not applicable for this service" }
  end
  
  with_options if: :dedicated_server? do |f|
    f.validates :server_name,         presence: true, host_name: true
    f.validates :username,            presence: true, if: :full_management?
    f.validates :server_rack_label,   presence: true
    f.validates :management_type_id,  presence: true
    f.validates :type_id,             inclusion: { in: [1, 3], message: "is not applicable for this service" }
  end
  
  with_options if: :private_email? do |f|
    f.validates :subscription_name,   presence: true
    f.validates :type_id,             inclusion: { in: [1, 2], message: "is not applicable for this service" }
  end
  
  with_options if: :eforward? do |f|
    f.validates :efwd_server_name,    presence: true, host_name: true
    f.validates :subscription_name,   presence: true
    f.validates :type_id,             inclusion: { in: [1], message: "is not applicable for this service" }
  end
  
  validates :suggestion_id,           presence: true
  validates :suspension_reason,       presence: true, if: :suspension_reason_required?
  validates :scan_report_path,        presence: true, if: :scan_report_path_required?
  
  with_options if: :processed? do |f|
    f.validates :processed_at,        presence: true
    f.validates :ticket_id,           presence: true
  end
  
  with_options if: :dismissed? do |f|
    f.validates :processed_at,        presence: true
    f.validates :legal_comments,      presence: true
  end
  
  validate :child_form_must_be_valid
  
  def child_form_must_be_valid
    child_form.errors.each { |key, val| errors.add "#{child_form.name}[#{key}]", val } if child_form && !child_form.valid?
  end
  
  def initialize hosting_abuse_id = nil
    @hosting_abuse = if hosting_abuse_id.present?
      Legal::HostingAbuse.find hosting_abuse_id
    else
      Legal::HostingAbuse.new
    end
  end
  
  def shared?()            service_id == 1   end
  def reseller?()          service_id == 2   end 
  def vps?()               service_id == 3   end
  def dedicated_server?()  service_id == 4   end
  def private_email?()     service_id == 5   end
  def eforward?()          service_id == 6   end
  
  def email_only?()        service_id == 1 && shared_plan_id == 6   end
  
  def spam?()              type_id == 1      end
  def resource_abuse?()    type_id == 2      end
  def ddos?()              type_id == 3      end
  
  def suspension_reason_required?()  [1, 2, 4].include? suggestion_id   end
  def scan_report_path_required?()   suggestion_id == 5                 end
  def full_management?()             management_type_id == 3            end
    
  def processed?()  status == 'processed'   end
  def dismissed?()  status == 'dismissed'   end
  
  def model
    @hosting_abuse
  end
  
  def server_name= name
    name = name.strip.downcase
    @server_id = Legal::HostingServer.find_or_create_by(name: name).id
    super name
  end
  
  def efwd_server_name= name
    name = name.strip.downcase
    @efwd_server_id = Legal::EforwardServer.find_or_create_by(name: name).id
    super name
  end
  
  def processed_at
    self.status == 'unprocessed' ? nil : DateTime.now
  end
  
  def submit params
    self.attributes = params
    
    if child_form
      child_form.attributes     = params[child_form.name]
      child_form.shared_plan_id = shared_plan_id
      child_form.service_id     = service_id
    end
    
    return false unless valid?
    persist!
    true
  end
  
  private
  
  def child_form
    @child_form ||= get_child_form
  end
  
  def get_child_form
    mapping = {
      1 => Legal::HostingAbuse::Form::Spam,
      2 => Legal::HostingAbuse::Form::Resource,
      3 => Legal::HostingAbuse::Form::Ddos
    }
    mapping[type_id].try :new
  end
  
  def persist!
    @hosting_abuse.assign_attributes hosting_abuse_params
    child_form.persist @hosting_abuse
    @hosting_abuse.save!
  end
  
  def hosting_abuse_params
    attr_names = Legal::HostingAbuse.attribute_names.map(&:to_sym)
    self.attributes.slice(*attr_names).delete_if { |key, val| val.nil? }
  end
  
end