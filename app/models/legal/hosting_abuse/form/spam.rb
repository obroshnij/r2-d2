class Legal::HostingAbuse::Form::Spam
  
  include Virtus.model(nullify_blank: true)
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :shared_plan_id, :service_id
  
  attribute :detection_method_id,             Integer
  attribute :other_detection_method,          String
  attribute :queue_type_ids,                  Array[Integer]
  attribute :outgoing_emails_queue,           Integer
  attribute :recepients_per_email,            Integer
  attribute :bounced_emails_queue,            Integer
  attribute :sent_emails_count,               Integer
  attribute :sent_emails_daterange,           String
  attribute :sent_emails_start_date,          Date
  attribute :sent_emails_end_date,            Date
  attribute :header,                          String
  attribute :body,                            String
  attribute :bounce,                          String
  attribute :logs,                            String
  attribute :example_complaint,               String
  attribute :content_type_id,                 Integer
  attribute :reporting_party_ids,             Array[Integer]
  attribute :experts_enabled,                 Boolean
  attribute :ip_is_blacklisted,               Boolean
  attribute :blacklisted_ip,                  String
  attribute :sent_by_cpanel,                  Boolean
  attribute :involved_mailboxes_count,        Integer
  attribute :mailbox_password_reset,          Boolean
  attribute :involved_mailboxes,              String
  attribute :mailbox_password_reset_reason,   String
  attribute :involved_mailboxes_count_other,  Integer
  attribute :reported_ip,                     String
  attribute :reported_ip_blacklisted,         Boolean
  
  validates :detection_method_id, presence: true
  
  with_options if: :queue? do |f|
    f.validates :queue_type_ids,                  presence: { message: 'at least one must be checked' }
    
    f.validates :outgoing_emails_queue,           presence: true, numericality: true,    if: -> { outbound_emails? || forwarded_emails? }
    f.validates :recepients_per_email,            presence: true, numericality: true,    if: -> { outbound_emails? || forwarded_emails? }
    f.validates :body,                            presence: true,                        if: -> { outbound_emails? || forwarded_emails? }
    f.validates :header,                          presence: true,                        if: -> { outbound_emails? || forwarded_emails? }
    
    f.validates :bounced_emails_queue,            presence: true, numericality: true,    if: :bounced_emails?
    f.validates :bounce,                          presence: true,                        if: :bounced_emails?
    
    f.validates :sent_emails_count,               presence: true, numericality: true,    if: :emails_sent_in_the_past?
    f.validates :sent_emails_daterange,           presence: true,                        if: :emails_sent_in_the_past?
    f.validates :logs,                            presence: true,                        if: :emails_sent_in_the_past?
  end

  with_options if: :feedback_loop? do |f|
    f.validates :example_complaint,               presence: true
    f.validates :reporting_party_ids,             presence: { message: 'at least one must be checked' }
    f.validates :reported_ip,                     presence: true, multiple_ips: true
  end
  
  validates :involved_mailboxes,                  presence: true,                     if: -> { sent_by_cpanel == false &&  low_mailboxes_count? &&  mailbox_password_reset }
  validates :mailbox_password_reset_reason,       presence: true,                     if: -> { sent_by_cpanel == false &&  low_mailboxes_count? && !mailbox_password_reset }
  validates :involved_mailboxes_count_other,      presence: true, numericality: true, if: -> { sent_by_cpanel == false && !low_mailboxes_count? }

  validates :other_detection_method,              presence: true,                     if: :other_detection_method?
  
  validates :blacklisted_ip,                      presence: true, multiple_ips: true, if: :blacklisted_ip_required?
  
  def name
    'spam'
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
  
  def outbound_emails?
    queue_type_ids.include? 1
  end
  
  def forwarded_emails?
    queue_type_ids.include? 2
  end
  
  def bounced_emails?
    queue_type_ids.include? 3
  end
  
  def emails_sent_in_the_past?
    queue_type_ids.include? 4
  end
  
  def low_mailboxes_count?
    [1, 2, 3, 4].include? involved_mailboxes_count
  end
  
  def blacklisted_ip_required?
    return true if [3, 4].include?(service_id)
    ip_is_blacklisted == true && (queue? || other_detection_method?)
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
    hosting_abuse.spam ||= Legal::HostingAbuse::Spam.new
    hosting_abuse.spam.assign_attributes spam_params
  end
  
  private
  
  def spam_params
    attr_names = Legal::HostingAbuse::Spam.attribute_names.map(&:to_sym) + [:reporting_party_ids, :queue_type_ids]
    self.attributes.slice(*attr_names).delete_if { |key, val| val.nil? }
  end  
end