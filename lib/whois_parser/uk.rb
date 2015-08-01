module WhoisParser
  class UK < Base
    
    def availability_pattern
      Regexp.new '(No match for "' + @domain_name + '".|Right of registration:)'
    end
    
    def status
      node('Registration status')
    end
    
    def nameservers
      node('Name servers').map do |line|
        line.split.first.strip
      end
    end
    
    def creation_date
      (DateTime.parse @whois_record.match(/Registered on:.+/).to_s.split.last).to_s rescue nil
    end
    
    def expiration_date
      (DateTime.parse @whois_record.match(/Expiry date:.+/).to_s.split.last).to_s rescue nil
    end
    
    def node(str)
      regexp = Regexp.new str + ':(.*?)\r\n\r\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + ':\r\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\r\n").map(&:strip)
    end
    
  end
end