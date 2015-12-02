class HostingAbuseForm
  
  class Spam
    
    include Virtus.model
    
    extend  ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Validations
    
    attribute :detection_methods,      Array[String]
    attribute :other_detection_method, String
    attribute :queue_amount,           Integer
    attribute :exim_stopped,           Boolean, default: true
    attribute :spam_experts_enabled,   Boolean, default: true
    attribute :blacklisted_ip,         String
    attribute :mailboxes_count,        Integer, default: 1
    attribute :mailboxes,              Array[String]
    attribute :header,                 String
    attribute :body,                   String
    
    attr_accessor :service
    
    DETECTION_METHODS = {
      queue_outbound:    "Queue (outbound)",
      queue_bounces:     "Queue (bounces)",
      captcha:           "CAPTCHA related",
      cms_notifications: "CMS notifications",
      forwarding_issue:  "Forwarding issue (*wildcard)",
      complaints:        "Complaints (e.g. from AOL)",
      blacklisted_ip:    "Our IP is blacklisted",
      mailbox_overflow:  "Mailbox Overflow",
      other:             "Other"
    }
    
    def mailboxes
      super.join(', ')
    end
    
    def exim_stopped_required?
      @service != 'pe'
    end
    
    def spam_experts_enabled_required?
      @service != 'pe'
    end
    
  end
  
end