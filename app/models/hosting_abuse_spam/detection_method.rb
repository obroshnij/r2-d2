class HostingAbuseSpam
  
  class DetectionMethod
    
    DETECTION_METHODS = {
      queue_outbound:    "Queue (outbound)",
      queue_bounces:     "Queue (bounces)",
      captcha:           "CAPTCHA related",
      cms_notifications: "CMS notifications",
      forwarding_issue:  "Forwarding issue (*wildcard)",
      feedback_loop:     "Feedback loop (AOL, Microsoft, Comcast, etc.)",
      blacklisted_ip:    "Our IP is blacklisted",
      mailbox_overflow:  "Mailbox Overflow",
      other:             "Other"
    }
    
    def self.all
      HostingAbuseSpam::DETECTION_METHODS.map do |value|
        { value: value, name: DETECTION_METHODS[value.to_sym] }
      end
    end
    
  end
  
end