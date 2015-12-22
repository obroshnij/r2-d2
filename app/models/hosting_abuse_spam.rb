class HostingAbuseSpam < ActiveRecord::Base
  
  DETECTION_METHODS = [
    :queue_outbound,
    :queue_bounces,
    :captcha,
    :cms_notifications,
    :forwarding_issue,
    :feedback_loop,
    :blacklisted_ip,
    :mailbox_overflow,
    :other
  ]

end