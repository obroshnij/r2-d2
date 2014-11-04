class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #------------- Whois Helpers -------------

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

  #------------- Maintenance Alerts Helpers -------------

  # Parse eNom maintenance alerts from http://www.enom.com/registrynews.asp
  def parse_alerts
    alerts = []
    maintenance_page = Nokogiri::HTML(open("http://www.enom.com/registrynews.asp"))
    maintenance_page.css('div.sCnt3.sFL').css('table').each do |table|
      alert = {}
      # Parse TLD (the left column)
      alert[:tlds] = "." + table.css('tbody').css('tr').css('td')[0].text.upcase
      # Parse message (the right column)
      alert[:message] = table.css('tbody').css('tr').css('td')[1].text.gsub(/(\r?\n){3,}/, '\1\1')
      # Extract :tlds from the message if needed
      alert[:tlds] = /.+and\s\.\w+/.match(alert[:message]).to_s if alert[:message] =~ /and\s\.\w+/
      # Remove :tlds from the message if needed
      alert[:message].gsub!(/.+and\s\.\w+/, '')
      # Extract the timeframe from the message
      alert[:timeframe] = /\w+\s\d+,\s\d{4}?.+/.match(alert[:message]).to_s
      # Remove the time frame from the message
      alert[:message].gsub!(/.+\w+\s\d+,\s\d{4}?.+\n/, '')
      # Remove extra spaces from the message
      alert[:message] = alert[:message].gsub(/(\r?\n){3,}/, '\1\1').strip
      alerts << alert
      break if table.next_element.text == "Product Maintenance Schedule"
    end
    alerts
  end

  #------------- Domains Info CSV Helpers -------------

  # Parse the CSV file + replace firstanme and lastname with fullname
  def parse_domains_info(csv_file)
    csv = SmarterCSV.process(csv_file.tempfile, strip_chars_from_headers: /'/)
    csv.each do |hash|
      name = hash[:firstname] + " " + hash[:lastname]
      hash.except!(:firstname, :lastname).merge!({ fullname: name })
    end
  end

end
