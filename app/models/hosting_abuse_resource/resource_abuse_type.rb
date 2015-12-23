class HostingAbuseResource
  
  class ResourceAbuseType
    
    TYPES = {
      cron_job:   'Cron Jobs',
      disc_space: 'Disc Space',
      lve_mysql:  'LVE / MySQL'
    }
    
    def self.all
      HostingAbuseResource.resource_abuse_types.map do |value, id|
        { value: value, name: TYPES[value.to_sym] }
      end
    end
    
  end
  
end