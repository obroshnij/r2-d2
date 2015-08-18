module WhoisParser
  class Base
    
    attr_accessor :domain_name, :whois_record
  
    def initialize(domain_name, whois_record)
      @domain_name, @whois_record = domain_name, whois_record
    end
  
    def parse
      %w{ available status nameservers creation_date expiration_date updated_date registrar registrant_contact admin_contact billing_contact tech_contact }.each_with_object({}) do |prop, hash|
        val = self.send(prop)
        hash[prop.to_sym] = val unless val.nil? || (val.respond_to?(:empty?) && val.empty?)
      end
    end
  
    def self.parse(domain_name, whois_record)
      self.new(domain_name, whois_record).parse
    end
    
    def available
      availability_pattern.nil? ? 'unknown' : @whois_record.match(availability_pattern).present?
    end
    
    def availability_pattern
      nil
    end
  
    def status
      node('status').map do |val|
        val.gsub(/\(?http.+/, "").gsub(/[^a-zA-Z[[:blank:]]]/, "").strip
      end.uniq.select { |val| val.present? }.sort
    end
  
    def nameservers
      node('name[[:blank:]]?servers?').map do |val|
        val.downcase
      end.uniq.select { |val| val.present? }.sort
    end
    
    def creation_date
      DateTime.parse(node('(?>create?i?o?n?|registration)[[:blank:]]*date').last).to_s rescue nil
    end
    
    def expiration_date
      DateTime.parse(node('(?>expiration|expiry)[[:blank:]]*date').last).to_s rescue nil
    end
    
    def updated_date
      DateTime.parse(node('updated[[:blank:]]*date').last).to_s rescue nil
    end
    
    def registrar
      node('registrar').first
    end
    
    def registrant_contact
      node('Registrant[a-z0-9[[:blank:]]/]*').delete_if { |el| el.blank? }.join("\n")
    end
    
    def admin_contact
      node('(?>Admin|Administrative)[a-z0-9[[:blank:]]/]*').delete_if { |el| el.blank? }.join("\n")
    end
    
    def billing_contact
      node('Billing[a-z0-9[[:blank:]]/]*').delete_if { |el| el.blank? }.join("\n")
    end
    
    def tech_contact
      node('(?>Tech|Technical)[a-z0-9[[:blank:]]/]*').delete_if { |el| el.blank? }.join("\n")
    end
  
    def node(str)
      regexp = Regexp.new str + '[[:blank:]]*:.+', Regexp::IGNORECASE
      val = @whois_record.scan(regexp)
      regexp = Regexp.new str + '[[:blank:]]*:', Regexp::IGNORECASE
      val.map { |s| s.gsub(regexp, "") }.each(&:strip!)
    end
    
  end
end