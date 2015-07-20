class Whois
  
  def self.lookup(object)
    self.new.lookup object
  end
  
  def lookup(object)
    if object.is_a? DomainName
      lookup_domain(object)
    elsif PublicSuffix.valid?(object)
      return lookup_string_nameserver(object) if PublicSuffix.parse(object).trd.present?
      return lookup_string_domain(object)     if PublicSuffix.parse(object).sld.present?
      return lookup_string_tld(object)        if PublicSuffix.parse(object).sld.blank?
    elsif IPAddress.valid?(object)
      lookup_ip(object)
    else
      raise ArgumentError, "\"#{object}\" is not a valid entry"
    end
  end
  
  def self.lookup_multiple(domains)
    whois = self.new
    threads = whois.split_by_whois_server(domains).map do |server, domains_array|
      Thread.new(domains_array) do |domains|
        whois = Whois.new
        domains.each { |d| whois.lookup d }
      end
    end.each(&:join)
  end
  
  def split_by_whois_server(domains)
    domains.each_with_object({}) do |domain, hash|
      server = get_whois_server(domain.tld)
      hash[server] ||= []
      hash[server] << domain
    end
  end
  
  private
  
  def lookup_domain(domain)
    whois_record = begin
      lookup_string_domain(domain.name)
    rescue
      nil
    end
    domain.whois = WhoisRecord.new domain.name, whois_record
  end
  
  def lookup_string_domain(string)
    domain = PublicSuffix.parse string
    server = get_whois_server domain.tld
    # TODO create a notification if whois server is not found
    return nil if server.blank?
    record = server == "whois.verisign-grs.com" ? execute(server, "domain #{domain.name}") : execute(server, domain.name)
    if server == "whois.verisign-grs.com"
      registrar_whois = record.match(/Whois Server:.+/).to_s.split.last
      record << execute(registrar_whois, domain.name) if registrar_whois.present?
    end
    raise Errno::ECONNRESET if record.include? "Your request is being rate limited"
    record.force_encoding "UTF-8"
  end
  
  def lookup_string_nameserver(string)
    domain = PublicSuffix.parse string
    server = get_whois_server domain.tld
    server == "whois.verisign-grs.com" ? execute(server, "nameserver #{domain.name}") : execute(server, domain.name)
  end
  
  def lookup_string_tld(string)
    domain = PublicSuffix.parse string
    execute "whois.iana.org", domain.tld
  end
  
  def lookup_ip(ip_address)
    ip = IPAddress.parse(ip_address).address
    record = execute("whois.iana.org", ip)
    server = record.match(/whois:.+/).to_s.split.last
    server.present? ? execute(server, ip) : record
  end
  
  def definitions
    @definitions ||= load_definitions
  end
  
  def get_whois_server(tld)
    server = definitions[tld]
    if server.nil?
      server = get_whois_server_from_whois tld
      add_whois_server_to_cache tld, server
    end
    server
  end
  
  DEFINITIONS_PATH = File.join(File.dirname(__FILE__), "whois_definitions.json")

  def load_definitions
    File.open(DEFINITIONS_PATH, "r") do |f|
      JSON.parse f.read
    end
  end

  def add_whois_server_to_cache(tld, server)
    if tld && server
      definitions[tld] = server
      File.open(DEFINITIONS_PATH, "w") do |f|
        f.write JSON.generate(definitions).gsub(",", ",\n ")
      end
    end
  end
  
  def get_whois_server_from_whois(tld)
    response = execute "whois.iana.org", tld
    response.match(/whois:.+/).to_s.split.last
  end
  
  ## Socket handler
  
  def local_ips
    Socket.ip_address_list.collect { |addr| addr.ip_address if addr.ip_address.match(/\d+\.\d+\.\d+\.\d+/) }.compact - ['127.0.0.1']
  end
  
  def execute(remote, query)
    addr = Addrinfo.tcp remote, 43
    Timeout::timeout(5) do
      addr.connect_from(local_ips.sample, rand(55000..65000)) do |socket|
        Rails.logger.debug "Looking up '#{query}' from '#{socket.local_address.inspect_sockaddr}'"
        socket.write "#{query}\r\n"
        socket.read
      end
    end
  end
  
end