module DomainBoxHelper

  def content(str)
    str ? str : ""
  end

  # Returns an array of host names / does not check if TLDs are valid
  def extract_host_names(str)
    str.downcase.scan(/(?:[a-z0-9\-]+\.)*(?:(?:xn--)?(?:[a-z0-9]+\-)*[a-z0-9]+\.)+[a-z]+/ix)
  end

  # Returns an array of valid domains / sub-domains are removed
  def parse_valid_domains(array)
    domains = []
    array.each do |host|
      domains << PublicSuffix.parse(host).domain if PublicSuffix.valid?(host)
    end
    domains
  end

  # Returns an array of valid sub-domains
  def parse_valid_subdomains(array)
    domains = []
    array.each do |host|
      if PublicSuffix.valid?(host)
        domains << (PublicSuffix.parse(host).subdomain ? PublicSuffix.parse(host).subdomain : PublicSuffix.parse(host).domain)
      end
    end
    domains
  end

  def count_occurrences(array)
    occurrences_count = array.each_with_object(Hash.new(0)) { |domain, hash| hash[domain] += 1 }
    occurrences_count.sort_by { |key, value| value }.reverse
  end

  def count_tlds(array)
    tlds_count = array.uniq.each_with_object(Hash.new(0)) { |domain, hash| hash[PublicSuffix.parse(domain).tld] += 1 }
    tlds_count.sort_by { |key, value| value }.reverse
  end

  def count_duplicates(array)
    duplicates_count = count_occurrences(array)
    duplicates_count.delete_if { |domain| domain.last <= 1 }
  end

  # Bulk Dig
  def initialize_resolver(type)
    return Net::DNS::Resolver.new if type == "default"
    return Net::DNS::Resolver.new(nameservers: ["8.8.8.8", "8.8.4.4"]) if type == "google"
    return Net::DNS::Resolver.new(nameservers: ["208.67.222.222", "208.67.220.220"]) if type == "open"
  end

  def record_type(str)
    return Net::DNS::A if str == "A"
    return Net::DNS::AAAA if str == "AAAA"
    return Net::DNS::MX if str == "MX"
    return Net::DNS::TXT if str == "TXT"
    return Net::DNS::NS if str == "NS"
    return Net::DNS::PTR if str == "PTR"
    Net::DNS::ANY
  end

end
