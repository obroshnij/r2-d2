module R2D2

  class Parser

    DOMAIN_REGEX = /(?:[a-z0-9\-]+\.)*(?:(?:xn--)?(?:[a-z0-9]+\-)*[a-z0-9]+\.)+[a-z]+/ix

    def self.parse_domains(options = {})
      host_names = self.extract_host_names(options[:text])
      domains = options[:remove_subdomains] ? self.parse_valid_domains(host_names) : self.parse_valid_subdomains(host_names)
      occurrences_count = options[:count_occurrences] ? self.count_occurrences(domains) : nil
      tlds_count = options[:count_tlds] ? self.count_tlds(domains) : nil
      duplicates_count = options[:count_duplicates] ? self.count_duplicates(domains) : nil
      { domains: domains.uniq.join("\n"), occurrences_count: occurrences_count, tlds_count: tlds_count, duplicates_count: duplicates_count }
    end

    private

    # Returns an array of host names / does not check if TLDs are valid
    def self.extract_host_names(str)
      str.downcase.scan(DOMAIN_REGEX)
    end

    # Returns an array of valid domains / sub-domains are removed
    def self.parse_valid_domains(array)
      array.each_with_object(Array.new) do |host, result|
        result << PublicSuffix.parse(host).domain if PublicSuffix.valid?(host)
      end
    end

    # Returns an array of valid sub-domains
    def self.parse_valid_subdomains(array)
      array.each_with_object(Array.new) do |host, result|
        if PublicSuffix.valid?(host)
          result << (PublicSuffix.parse(host).subdomain ? PublicSuffix.parse(host).subdomain : PublicSuffix.parse(host).domain)
        end
      end
    end

    def self.count_occurrences(array)
      occurrences_count = array.each_with_object(Hash.new(0)) { |domain, hash| hash[domain] += 1 }
      occurrences_count.sort_by { |key, value| value }.reverse
    end

    def self.count_tlds(array)
      tlds_count = array.uniq.each_with_object(Hash.new(0)) { |domain, hash| hash[PublicSuffix.parse(domain).tld] += 1 }
      tlds_count.sort_by { |key, value| value }.reverse
    end

    def self.count_duplicates(array)
      duplicates_count = count_occurrences(array)
      duplicates_count.delete_if { |domain| domain.last <= 1 }
    end

  end

end