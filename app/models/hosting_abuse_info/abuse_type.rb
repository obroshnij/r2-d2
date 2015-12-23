class HostingAbuseInfo
  
  class AbuseType
    
    HOSTING_ABUSE_TYPES = {
      spam:       'Email Abuse / Spam',
      resource:   'Resource Abuse',
      ddos:       'DDoS'
    }
    
    def self.all
      HostingAbuseInfo.hosting_abuse_types.map do |value, id|
        { value: value, name: HOSTING_ABUSE_TYPES[value.to_sym] }
      end
    end
    
  end
  
end