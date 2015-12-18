class HostingAbuseInfo
  
  class ResellerPackage
    
    RESELLER_PACKAGES = {
      one:   'Reseller 1',
      two:   'Reseller 2',
      three: 'Reseller 3',
      four:  'Reseller 4'
    }
    
    def self.all
      HostingAbuseInfo.reseller_packages.map do |value, id|
        { value: value, name: RESELLER_PACKAGES[value.to_sym] }
      end
    end
    
  end
  
end