class HostingAbuseInfo
  
  class HostingService
    
    HOSTING_SERVICES = {
      shared:    'Shared Package',
      reseller:  'Reseller Package',
      vps:       'VPS Hosting',
      dedicated: 'Dedicated Server',
      pe:        'Private Email'
    }
    
    def self.all
      HostingAbuseInfo.hosting_services.map do |value, id|
        { id: id, value: value, name: HOSTING_SERVICES[value.to_sym] }
      end
    end
    
  end
  
end