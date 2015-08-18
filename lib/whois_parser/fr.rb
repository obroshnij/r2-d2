module WhoisParser
  class FR < Base
    
    def availability_pattern
      Regexp.new 'No entries found in the AFNIC Database'
    end
    
    def status
      return nil if node('status').blank?
      status = [node('status').first]
      status << 'HOLD' unless node('hold').first == 'NO'
      status.sort
    end
    
    def nameservers
      node('nserver').map(&:downcase).uniq
    end
    
    def creation_date
      DateTime.parse(node('created').first).to_s rescue nil
    end
    
    def updated_date
      DateTime.parse(node('last-update').first).to_s rescue nil
    end
    
    def registrant_contact
      contact_node node('holder-c').first if node('holder-c').present?
    end
    
    def admin_contact
      contact_node node('admin-c').first if node('admin-c').present?
    end
    
    def tech_contact
      contact_node node('tech-c').first if node('tech-c').present?
    end
    
    def contact_node(str)
      regexp = Regexp.new 'nic-hdl:[[:blank:]]*' + str + '(.*?)\n\n', Regexp::IGNORECASE | Regexp::MULTILINE
      @whois_record.match(regexp).to_s.split("\n").delete_if do |line|
        !%w{type contact address country phone fax-no e-mail}.include?(line.split(':').first)
      end.map { |line| line.split(/:[[:blank:]]+/).last }.join("\n")
    end
    
  end
end
