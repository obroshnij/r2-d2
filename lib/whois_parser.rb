module WhoisParser
  
  def self.parse(domain_name, whois_record)
    properties = get_parser(domain_name).parse domain_name, whois_record
    if properties[:available] == 'unknown'
      properties[:available] = properties.keys.count == 1
    end
    properties
  end
  
  private
  
  def self.get_tld(domain_name)
    PublicSuffix.parse(domain_name).tld
  end
  
  def self.get_parser(domain_name)
    const_get 'WhoisParser::' + get_tld(domain_name).split('.').last.upcase, false
  rescue NameError
    WhoisParser::Base
  end
  
end