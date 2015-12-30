class HostingAbuseResource
  
  class ResourceType
    
    TYPES = {
      cpu:       'CPU Usage',
      memory:    'Memory Usage',
      entry:     'Entry Processes',
      io:        'Input / Output',
      mysql:     'MySQL Queries',
      processes: 'Number of (simultaneous) Processes Failed'
    }
    
    def self.all
      TYPES.map do |key, val|
        { value: key.to_s, name: val }
      end
    end
    
  end
  
end