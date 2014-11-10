module WhoisHelper

  # Perform Whois lookup and return the record
  def whois_lookup(str)
    str = str.strip.downcase
    PublicSuffix::List.private_domains = false
    # Check if the provided sting is a valid domain, TLD or IP address
    raise "\"#{str}\" is not a valid entry" unless IPAddress.valid?(str) || PublicSuffix.valid?(str)
    # Perform Whois lookup if the string is an IP address
    return Whois.whois(IPAddress.parse(str).address).to_s if IPAddress.valid?(str)
    # Perform Whois lookup if the string is a TLD
    return Whois.whois(str).to_s unless PublicSuffix.parse(str).sld
    # Otherwise, lookup the domain using appropriate server
    whois_server(str).lookup(str).to_s
  end

  def whois_server(str)
    tld = PublicSuffix.parse(str).tld
    # TLDs that have no Whois server listed at IANA
    return Whois::Server.factory :tld, ".nyc", "whois.nic.nyc" if tld == "nyc"
    return Whois::Server.factory :tld, ".trade", "whois.nic.trade" if tld == "trade"
    # Bug in the Whois gem - incorrect server is returned
    return Whois::Server.factory :tld, ".link", "whois.uniregistry.net" if tld == "link"
    # Get the Whois server
    Whois::Server.guess(str)
  rescue Whois::ServerNotFound
    host = Whois.whois(".#{tld}").match(/whois.+/).to_s.split.last
    raise "Unable to find a WHOIS server for .#{tld.upcase}" unless host
    Whois::Server.factory :tld, ".#{tld}", host
  end

end