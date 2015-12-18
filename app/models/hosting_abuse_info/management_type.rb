class HostingAbuseInfo
  
  class ManagementType
    
    MANAGEMENT_TYPES = {
      not_managed:    "None",
      partially:      "Partially Managed",
      fully:          "Fully Managed"
    }
    
    def self.all
      HostingAbuseInfo.management_types.map do |value, id|
        { value: value, name: MANAGEMENT_TYPES[value.to_sym] }
      end
    end
    
  end
  
end