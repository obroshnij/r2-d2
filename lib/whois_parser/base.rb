module WhoisParser
  class Base
    
    attr_accessor :domain_name
  
    def initialize(domain_name, whois_record)
      @domain_name, @whois_record = domain_name, whois_record
    end
  
    def parse
      %w{ available status nameservers creation_date expiration_date updated_date registrar }.each_with_object({}) do |prop, hash|
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
      end.uniq.select { |val| val.present? }
    end
  
    def nameservers
      node('name[[:blank:]]?servers?').map do |val|
        val.downcase
      end.uniq.select { |val| val.present? }
    end
    
    def creation_date
      DateTime.parse(node('(?>creation|registration)[[:blank:]]*date').last).to_s rescue nil
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
  
    def node(str)
      regexp = Regexp.new str + '[[:blank:]]*:.+', Regexp::IGNORECASE
      val = @whois_record.scan(regexp)
      regexp = Regexp.new str + '[[:blank:]]*:', Regexp::IGNORECASE
      val.map { |s| s.gsub(regexp, "") }.each(&:strip!)
    end
    
  end
end