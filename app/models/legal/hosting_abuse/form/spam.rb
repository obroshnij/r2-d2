class Legal::HostingAbuse::Form::Spam
  
  include Virtus.model(nullify_blank: true)
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :service_id
  
  attribute :detection_method_id,             Integer
  attribute :other_detection_method,          String
  attribute :queue_type_id,                   Integer
  attribute :bounces_queue_present,           Boolean
  attribute :outgoing_emails_queue,           Integer
  attribute :recepients_per_email,            Integer
  attribute :bounced_emails_queue,            Integer
  attribute :header,                          String
  attribute :body,                            String
  attribute :bounce,                          String
  attribute :example_complaint,               String
  attribute :reporting_party_ids,             Array[Integer]
  attribute :experts_enabled,                 Boolean
  attribute :ip_is_blacklisted,               Boolean
  attribute :blacklisted_ip,                  String
  attribute :involved_mailboxes_count,        Integer
  attribute :mailbox_password_reset,          Boolean
  attribute :involved_mailboxes,              String
  attribute :mailbox_password_reset_reason,   String
  attribute :involved_mailboxes_count_other,  Integer
  attribute :reported_ip,                     String
  attribute :reported_ip_blacklisted,         Boolean
  
  # validates :other_detection_method,          presence: true,                     if: :other_detection_method?
#   validates :queue_amount,                    presence: true, numericality: true, if: :queue?
#   validates :blacklisted_ip,                  presence: true, ip_address: true,   if: :ip_is_blacklisted
#   validates :example_complaint,               presence: true,                     if: :feedback_loop?
#   validates :reporting_party_id,              presence: true,                     if: :feedback_loop?
#   validates :reported_ip,                     presence: true, ip_address: true,   if: :feedback_loop?
#   validates :header,                          presence: true,                     if: -> { queue? && !bounced_emails? }
#   validates :body,                            presence: true,                     if: -> { queue? && !bounced_emails? }
#   validates :bounce,                          presence: true,                     if: -> { queue? &&  bounced_emails? }
#
#   validates :involved_mailboxes_count_other,  presence: true, numericality: true, if: -> { !private_email? && !low_mailboxes_count? }
#   validates :involved_mailboxes,              presence: true,                     if: -> { !private_email? &&  low_mailboxes_count? &&  mailbox_password_reset }
#   validates :mailbox_password_reset_reason,   presence: true,                     if: -> { !private_email? &&  low_mailboxes_count? && !mailbox_password_reset }
  
  def queue?
    detection_method_id == 1
  end
  
  def feedback_loop?
    detection_method_id == 2
  end
  
  def other_detection_method?
    detection_method_id == 3
  end
  
  def low_mailboxes_count?
    [1, 2, 3, 4].include? involved_mailboxes_count
  end
  
  def bounced_emails?
    queue_type_id == 2
  end
  
  def private_email?
    service_id == 5
  end
  
end