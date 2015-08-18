module WhoisParser
  class PE < Base
    
    def availability_pattern
      Regexp.new 'Status: Not Registered'
    end
    
    def status
      node('status') == ['Not Registered'] ? nil : super
    end
    
    def nameservers
      split_node('name servers').map(&:downcase).sort
    end
    
    def registrant_contact
      split_node('registrant').join("\n")
    end
    
    def admin_contact
      split_node('administrative contact').join("\n")
    end
    
    def split_node(str)
      regexp = Regexp.new str + ':(.*?)\n\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + ':\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\n").map(&:strip)
    end
    
  end
end