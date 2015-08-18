module WhoisParser
  class CH < Base
    
    def initialize(domain_name, whois_record)
      super
      @whois_record << "\n"
    end
    
    def availability_pattern
      Regexp.new 'We do not have an entry in our database matching your query'
    end
    
    def registrant_contact
      node('Holder of domain name').join("\n")
    end
    
    def node(str)
      regexp = Regexp.new str + ':(.*?)\n\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + ':\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\n").map(&:strip)
    end
    
  end
end