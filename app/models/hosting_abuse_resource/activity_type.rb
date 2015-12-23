class HostingAbuseResource
  
  class ActivityType
    
    def self.all
      HostingAbuseResource.activity_types.map do |value, id|
        { value: value, name: value.humanize }
      end
    end
    
  end
  
end