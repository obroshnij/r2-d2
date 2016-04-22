class Legal::HostingAbuse::Form::PeSpam
  
  include Virtus.model(nullify_blank: true)
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :shared_plan_id, :service_id
  
  attribute :detection_method_id,             Integer
  attribute :pe_content_type_id,              Integer
  attribute :other_detection_method,          String
  attribute :pe_queue_type_ids,               Array[Integer]
  attribute :sent_emails_amount,              Integer
  attribute :recepients_per_email,            Integer
  attribute :sent_emails_daterange,           String
  attribute :sent_emails_start_date,          Date
  attribute :sent_emails_end_date,            Date
  attribute :example_complaint,               String
  attribute :reporting_party_ids,             Array[Integer]
  attribute :ip_is_blacklisted,               Boolean
  attribute :blacklisted_ip,                  String
  attribute :reported_ip,                     String
  attribute :reported_ip_blacklisted,         Boolean
  attribute :postfix_deferred_queue,          Integer
  attribute :postfix_active_queue,            Integer
  attribute :mailer_daemon_queue,             Integer
  attribute :header,                          String
  attribute :body,                            String
  attribute :bounce,                          String
  attribute :outbound_blocked,                Boolean
  
  validates :detection_method_id, presence: true
  
  with_options if: :queue? do |f|
    f.validates :pe_queue_type_ids,           presence: { message: 'at least one must be checked' }
    
    f.validates :sent_emails_daterange,       presence: true,                     if: :sent_emails?
    f.validates :sent_emails_amount,          presence: true,                     if: :sent_emails?
    f.validates :recepients_per_email,        presence: true,                     if: :sent_emails?
    
    f.validates :postfix_deferred_queue,      presence: true, numericality: true, if: :postfix_deferred?
    
    f.validates :postfix_active_queue,        presence: true, numericality: true, if: :postfix_active?
    
    f.validates :mailer_daemon_queue,         presence: true, numericality: true, if: :bounced?
    f.validates :bounce,                      presence: true,                     if: :bounced?
    
    f.validates :header,                      presence: true,                     if: -> { sent_emails? || postfix_deferred? || postfix_active? }
    f.validates :body,                        presence: true,                     if: -> { sent_emails? || postfix_deferred? || postfix_active? }
  end
  
  with_options if: :feedback_loop? do |f|
    f.validates :example_complaint,           presence: true
    f.validates :reporting_party_ids,         presence: { message: 'at least one must be checked' }
    f.validates :reported_ip,                 presence: true, multiple_ips: true
  end
  
  validates :other_detection_method,          presence: true,                     if: :other_detection_method?
  
  validates :blacklisted_ip,                  presence: true, multiple_ips: true, if: -> { ip_is_blacklisted == true && (queue? || other_detection_method?) }
  
  def name
    'pe_spam'
  end
  
  def queue?
    detection_method_id == 1
  end
  
  def feedback_loop?
    detection_method_id == 2
  end
  
  def other_detection_method?
    detection_method_id == 3
  end
  
  def sent_emails?
    pe_queue_type_ids.include? 1
  end
  
  def postfix_deferred?
    pe_queue_type_ids.include? 2
  end
  
  def postfix_active?
    pe_queue_type_ids.include? 3
  end
  
  def bounced?
    pe_queue_type_ids.include? 4
  end
  
  def queue_type_ids= ids
    super ids.present? ? ids.delete_if(&:blank?) : []
  end
  
  def reporting_party_ids= ids
    super ids.present? ? ids.delete_if(&:blank?) : []
  end
  
  def sent_emails_daterange= range
    @sent_emails_start_date = Date.parse range.split(' - ').first rescue nil
    @sent_emails_end_date   = Date.parse range.split(' - ').last  rescue nil
    super
  end
  
  def ip_is_blacklisted= blacklisted
    @ip_is_blacklisted = 'N/A' and return if blacklisted == ""
    super
  end
  
  def reported_ip= ips
    super ips.split.map(&:strip).join("\n")
  end
  
  def blacklisted_ip= ips
    super ips.split.map(&:strip).join("\n")
  end
  
  def persist hosting_abuse
    hosting_abuse.pe_spam ||= Legal::HostingAbuse::PeSpam.new
    hosting_abuse.pe_spam.assign_attributes pe_spam_params
  end
  
  private
  
  def pe_spam_params
    attr_names = Legal::HostingAbuse::PeSpam.attribute_names.map(&:to_sym) + [:reporting_party_ids, :pe_queue_type_ids]
    self.attributes.slice(*attr_names).delete_if { |key, val| val.nil? }
  end
end