class HostingAbuseSpam < ActiveRecord::Base
  
  DETECTION_METHODS = [
    :queue_outbound,
    :queue_bounces,
    :captcha,
    :forwarding_issue,
    :feedback_loop,
    :blacklisted_ip,
    :system_notifications,
    :other
  ]

end