module WhoisParser
  class EU < Base
    
    def availability_pattern
      Regexp.new 'Domain: ' + @domain_name + "\n" + 'Status: AVAILABLE'
    end
    
    def status
      nil
    end
    
    def nameservers
      node('Name servers').sort
    end
    
    def registrar
      node('Registrar').first
    end
    
    def registrant_contact
      node('Registrant').join("\n")
    end
    
    def tech_contact
      node('Technical').join("\n")
    end
    
    def node(str)
      regexp = Regexp.new str + ':(.*?)\n\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + ':\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\n").map { |line| line.split(': ').last.strip }
    end
    
  end
end