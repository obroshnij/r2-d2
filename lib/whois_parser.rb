module WhoisParser
  
  def self.parse(domain_name, whois_record)
    get_parser(domain_name).parse domain_name, whois_record
  end
  
  private
  
  def self.get_tld(domain_name)
    PublicSuffix.parse(domain_name).tld
  end
  
  def self.get_parser(domain_name)
    const_get get_tld(domain_name).upcase, false
  rescue NameError
    WhoisParser::Base
  end
  
end