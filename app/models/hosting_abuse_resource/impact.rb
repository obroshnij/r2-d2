class HostingAbuseResource
  
  class Impact
    
    def self.all
      HostingAbuseResource.impacts.map do |value, id|
        { value: value, name: value.humanize }
      end
    end
    
  end
  
end