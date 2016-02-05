class Legal::HostingAbuse::Form::Spam
  
  include Virtus.model(nullify_blank: true)
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :service_id
  
  attribute :detection_method_id,             Integer
  attribute :other_detection_method,          String
  attribute :queue_type_ids,                  Array[Integer]
  attribute :outgoing_emails_queue,           Integer
  attribute :recepients_per_email,            Integer
  attribute :bounced_emails_queue,            Integer
  attribute :sent_emails_count,               Integer
  attribute :sent_emails_daterange,           String
  attribute :header,                          String
  attribute :body,                            String
  attribute :bounce,                          String
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
    
    f.validates :outgoing_emails_queue,           presence: true, numericality: true,                   if: -> { outbound_emails? || forwarded_emails? }
    f.validates :recepients_per_email,            presence: true, numericality: true,                   if: -> { outbound_emails? || forwarded_emails? }
    f.validates :body,                            presence: true,                                       if: -> { outbound_emails? || forwarded_emails? }
    f.validates :header,                          presence: true,                                       if: -> { outbound_emails? || forwarded_emails? }
    
    f.validates :bounced_emails_queue,            presence: true, numericality: true,                   if: :bounced_emails?
    f.validates :bounce,                          presence: true,                                       if: :bounced_emails?
    
    f.validates :sent_emails_count,               presence: true, numericality: true,                   if: :emails_sent_in_the_past?
    f.validates :sent_emails_daterange,           presence: true,                                       if: :emails_sent_in_the_past?
  end

  with_options if: :feedback_loop? do |f|
    f.validates :example_complaint,               presence: true
    f.validates :reporting_party_ids,             presence: { message: 'at least one must be checked' }
    f.validates :reported_ip,                     presence: true, ip_address: true
  end

  validates :other_detection_method,              presence: true,                   if: :other_detection_method?
  
  validates :blacklisted_ip,                      presence: true, ip_address: true, if: -> { ip_is_blacklisted? && (queue? || other_detection_method?) }
  
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
  
  def queue_type_ids= ids
    super ids.delete_if(&:blank?)
  end
  
  def reporting_party_ids= ids
    super ids.delete_if(&:blank?)
  end
  
end