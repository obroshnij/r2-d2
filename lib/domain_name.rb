class DomainName
  
  DOMAIN_REGEX = /(?:(?:[a-z0-9]+[a-z0-9\-]*)*[a-z0-9]+\.)+[a-z]+/
  
  attr_accessor :tld, :sld, :prefix, :extra_attr
  
  def initialize(host_name, extra_attr = {}, whois = nil)
    domain = PublicSuffix.parse host_name
    @tld, @sld, @prefix, @extra_attr, @whois = domain.tld, domain.sld, domain.trd, extra_attr, WhoisRecord.new(domain.name, whois)
  rescue PublicSuffix::DomainInvalid
    raise ArgumentError, "Invalid domain"
  end
  
  def name
    [@prefix, @sld, @tld].compact.join(".")
  end
  
  def self.parse_multiple(text, params = {})
    hosts = self.extract_valid_host_names text, params[:remove_subdomains]
    hosts_with_count = hosts.each_with_object(Hash.new(0)) { |host, hash| hash[host] += 1 }
    hosts_with_count.map do |host, count|
      begin
        self.new host, occurrences_count: count
      rescue ArgumentError
        nil
      end
    end.compact
  end
  
  def whois
    @whois
  end
  
  def whois!
    Whois.lookup(self)
  end
  
  def whois=(record)
    raise AgrumentError, "Argument must be a WhoisRecord instance" unless record.is_a? WhoisRecord
    @whois = record
  end
  
  def to_h
    { domain_name: self.name, extra_attr: self.extra_attr, whois: self.whois.try(:record), whois_attr: self.whois.try(:properties) }
  end
  
  def self.multiple_to_hash(domains)
    domains.each_with_object({}) do |domain, hash|
      hash[domain.name] = { extra_attr: domain.extra_attr, whois: domain.whois.try(:record), whois_attr: domain.whois.try(:properties) }
    end
  end
  
  private
  
  def self.extract_valid_host_names(text, remove_subdomains)
    text.downcase.scan(DOMAIN_REGEX).map do |host|
      begin
        name = PublicSuffix.parse host
        remove_subdomains == true ? name.domain : name.subdomain || name.domain
      rescue PublicSuffix::DomainInvalid
        next
      end
    end
  end
  
end