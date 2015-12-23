class HostingAbuseResource
  
  class UpgradeSuggestion
    
    SUGGESTIONS = {
      business_ssd: 'Business SSD',
      vps_one:      'VPS 1 - XEN',
      vps_two:      'VPS 2 - XEN',
      vps_three:    'VPS 3 - XEN',
      dedicated:    'Dedicated Server'
    }
    
    def self.all
      HostingAbuseResource.upgrade_suggestions.map do |value, id|
        { value: value, name: SUGGESTIONS[value.to_sym] }
      end
    end
    
  end
  
end