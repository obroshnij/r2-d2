module WhoisParser
  class AU < Base
    
    def availability_pattern
      Regexp.new 'No Data Found'
    end
    
    def updated_date
      DateTime.parse(node('Last Modified').last).to_s rescue nil
    end
    
    def registrar
      node('Registrar Name').first
    end
    
    def registrant_contact
      super + "\nEligibility:\n" + node('Eligibility[a-z0-9[[:blank:]]/]*').delete_if { |el| el.blank? }.join("\n") if super.present?
    end
    
  end
end