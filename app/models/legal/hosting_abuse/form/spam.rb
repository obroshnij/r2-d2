class Legal::HostingAbuse::Form::Spam
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :detection_method_id,             Integer
  attribute :other_detection_method,          String
  attribute :queue_type_id,                   Integer
  attribute :header,                          String
  attribute :body,                            String
  attribute :bounce,                          String
  attribute :queue_amount,                    String
  attribute :ip_is_blacklisted,               Boolean
  attribute :blacklisted_ip,                  String
  attribute :example_complaint,               String
  attribute :reporting_party_id,              Integer
  attribute :experts_enabled,                 Boolean
  attribute :involved_mailboxes_count,        Integer
  attribute :mailbox_password_reset,          Boolean
  attribute :involved_mailboxes,              String
  attribute :mailbox_password_reset_reason,   String
  attribute :involved_mailboxes_count_other,  Integer
  
  validates :other_detection_method,          presence: true, if: :other_detection_method?
  validates :queue_amount,                    presence: true, if: :queue_amount_required?
  validates :blacklisted_ip,                  presence: true, if: :ip_is_blacklisted
  validates :involved_mailboxes_count_other,  presence: true, unless: :low_mailboxes_count?
  validates :involved_mailboxes,              presence: true, if: :mailbox_password_reset
  validates :mailbox_password_reset_reason,   presence: true, unless: :mailbox_password_reset
  validates :example_complaint,               presence: true, if: :feedback_loop?
  validates :reporting_party_id,              presence: true, if: :feedback_loop?
  validates :header,                          presence: true, if: lambda { queue? && !bounced_emails? }
  validates :body,                            presence: true, if: lambda { queue? && !bounced_emails? }
  validates :bounce,                          presence: true, if: lambda { queue? && bounced_emails? }
  
  def queue?
    detection_method_id == 1
  end
  
  def feedback_loop?
    detection_method_id == 2
  end
  
  def other_detection_method?
    detection_method_id == 3
  end
  
  def queue_amount_required?
    !feedback_loop?
  end
  
  def low_mailboxes_count?
    [1, 2, 3, 4].include? involved_mailboxes_count
  end
  
  def bounced_emails?
    queue_type_id == 2
  end
  
end