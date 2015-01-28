module R2D2

  class Whoiz

    # Perform a Whois lookup and return the Whois record
    def self.lookup(string)
      Retriable.retriable on: Errno::ECONNRESET, tries: 5, base_interval: 1 do
        string = string.strip.downcase
        # Check if the provided sting is a valid domain, TLD or IP address
        raise ArgumentError, "\"#{string}\" is not a valid entry" unless IPAddress.valid?(string) || PublicSuffix.valid?(string)
        # Perform Whois lookup if the string is an IP address
        return Whois.whois(IPAddress.parse(string).address).to_s if IPAddress.valid?(string)
        # Perform Whois lookup if the string is a TLD
        return Whois.whois(string).to_s unless PublicSuffix.parse(string).sld
        # Otherwise, lookup the domain using appropriate server
        get_whois_server(string).lookup(string).to_s
      end
    end

    def self.epp_status(domain)
      Retriable.retriable on: Errno::ECONNRESET, tries: 5, base_interval: 1 do
        if %w{ mobi me }.include? PublicSuffix.parse(domain.downcase).tld
          self.lookup(domain).to_s.scan(/(?<=Status:)[a-zA-Z[[:blank:]]]+/)
        else
          self.lookup(domain).to_s.scan(/(?<=Status:)[[:blank:]]*[a-zA-Z]+[[:blank:]]*/).each { |s| s.gsub!(/[[:space:]]/, '') }.uniq
        end
      end
    end

    def self.nameservers(domain)
      Retriable.retriable on: Errno::ECONNRESET, tries: 5, base_interval: 1 do
        if %w{ me }.include? PublicSuffix.parse(domain.downcase).tld
          result = self.lookup(domain).to_s.scan(/(?<=Nameservers:).+/).each { |ns| ns.strip!.downcase! }.uniq.delete_if { |ns| ns.empty? }
        else
          result = self.lookup(domain).to_s.scan(/(?<=Name Server:)[[:blank:]]*.+/).each { |ns| ns.strip!.downcase! }.uniq
        end
      end
    end

    private

    # Get Whois server for the specified TLD
    def self.get_whois_server(string)
      Retriable.retriable on: Errno::ECONNRESET, tries: 5, base_interval: 1 do
        tld = PublicSuffix.parse(string).tld
        # TLDs that have no Whois server listed at IANA
        return Whois::Server.factory :tld, ".nyc", "whois.nic.nyc" if tld == "nyc"
        return Whois::Server.factory :tld, ".trade", "whois.nic.trade" if tld == "trade"
        # Bug in the Whois gem - incorrect server is returned
        return Whois::Server.factory :tld, ".link", "whois.uniregistry.net" if tld == "link"
        # Get the Whois server
        Whois::Server.guess(string)
      rescue Whois::ServerNotFound
        # Try to parse the server from a Whois record for the TLD
        host = Whois.whois(".#{tld}").match(/whois.+/).to_s.split.last
        # Raise exception if no server is found
        raise Whois::ServerNotFound, "Unable to find a Whois server for .#{tld.upcase}" unless host
        # Return Whois::Server instance
        Whois::Server.factory :tld, ".#{tld}", host
      end
    end

  end

end