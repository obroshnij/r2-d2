module WhoisParser
  class DE < Base
    
    def initialize(domain_name, whois_record)
      super
      @whois_record << "\n"
    end
    
    def status
      node('status') == ['free'] ? nil : super
    end
    
    def nameservers
      node('nserver').map(&:downcase).sort
    end
    
    def updated_date
      DateTime.parse(node('changed').first).to_s rescue nil
    end
    
    def tech_contact
      contact_node('\[Tech-C\]')[0..-2].map do |line|
        line.split(': ').last
      end.join("\n")
    end
    
    def admin_contact
      contact_node('\[Zone-C\]')[0..-2].map do |line|
        line.split(': ').last
      end.join("\n")
    end
    
    def contact_node(str)
      regexp = Regexp.new str + '(.*?)\n\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + '\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\n").map(&:strip)
    end
    
  end
end