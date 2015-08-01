module WhoisParser
  class IO < Base
    
    def nameservers
      node('ns[[:blank:]]\d').map do |val|
        val.downcase
      end.uniq
    end
    
    def expiration_date
      (DateTime.parse node('Expiry').first).to_s rescue nil
    end
    
    def availability_pattern
      Regexp.new 'Domain ' + @domain_name + ' is available for purchase'
    end
    
  end
end