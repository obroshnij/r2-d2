module WhoisParser
  class SG < Base
    
    def status
      node('status').sort
    end
    
    def nameservers
      split_node('name servers').map { |val| val.split.first.downcase }.sort
    end
    
    def updated_date
      DateTime.parse(node('modified date').first).to_s rescue nil
    end
    
    def registrant_contact
      split_node('registrant').map { |val| val.split(/:[[::blank]]*/).last.strip }.join("\n")
    end
    
    def admin_contact
      split_node('administrative contact').map { |val| val.split(/:[[::blank]]*/).last.strip }.join("\n")
    end
    
    def tech_contact
      split_node('technical contact').map { |val| val.split(/:[[::blank]]*/).last.strip }.join("\n")
    end
    
    def split_node(str)
      regexp = Regexp.new str + ':(.*?)\r\n\r\n\r\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val = @whois_record.match(regexp).to_s
      regexp = Regexp.new str + ':\r\n', Regexp::IGNORECASE | Regexp::MULTILINE
      val.gsub(regexp, '').split("\r\n").map(&:strip).delete_if(&:blank?)
    end
    
  end
end