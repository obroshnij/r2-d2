class HostingAbuseInfo
  
  class AbuseType
    
    HOSTING_ABUSE_TYPES = {
      spam:        'Email Abuse / Spam',
      ip_feedback: 'IP Feedback',
      lve_mysql:   'Resource Abuse (LVE/MySQL)',
      disc_space:  'Resource Abuse (Disc Space)',
      cron_job:    'Resource Abuse (Cron Jobs)',
      ddos:        'DDoS'
    }
    
    def self.all
      HostingAbuseInfo.hosting_abuse_types.map do |value, id|
        { value: value, name: HOSTING_ABUSE_TYPES[value.to_sym] }
      end
    end
    
  end
  
end