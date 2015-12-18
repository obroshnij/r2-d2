class HostingAbuseInfo
  
  class SharedPackage
    
    SHARED_PACKAGES = {
      value:        'Value',
      business:     'Business',
      professional: 'Professional',
      ultimate:     'Ultimate'
    }
    
    def self.all
      HostingAbuseInfo.shared_packages.map do |value, id|
        { value: value, name: SHARED_PACKAGES[value.to_sym] }
      end
    end
    
  end
  
end