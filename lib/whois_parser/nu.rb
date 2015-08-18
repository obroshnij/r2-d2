module WhoisParser
  class NU < Base
    
    def status
      node('state') + node('status').sort
    end
    
    def nameservers
      node('nserver').map(&:downcase).sort.uniq
    end
    
    def creation_date
      DateTime.parse(node('created').last).to_s rescue nil
    end
    
    def expiration_date
      DateTime.parse(node('expires').last).to_s rescue nil
    end
    
    def updated_date
      DateTime.parse(node('modified').last).to_s rescue nil
    end
    
  end
end