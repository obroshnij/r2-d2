module WhoisParser
  class CA < Base
    
    def availability_pattern
      Regexp.new 'Domain name:[[:blank:]]+' + @domain_name + '\n' + 'Domain status:[[:blank:]]+available'
    end
    
    def status
      nil
    end
    
    def nameservers
      node('Name servers').map { |val| val.split.first }.sort
    end
    
    def creation_date
      DateTime.parse(@whois_record.match(/Creation date:.+/).to_s.split.last).to_s rescue nil
    end

    def expiration_date
      DateTime.parse(@whois_record.match(/Expiry date:.+/).to_s.split.last).to_s rescue nil
    end

    def updated_date
      DateTime.parse(@whois_record.match(/Updated date:.+/).to_s.split.last).to_s rescue nil
    end
    
    def node(str)
      regexp = Regexp.new str + ':(.*?)\n\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + ':\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\n").delete_if { |line| line.match(/[a-z0-9]+:\Z/i) }.map { |line| line.split(': ').last.strip }
    end
    
  end
end