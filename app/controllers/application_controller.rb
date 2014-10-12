class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #------------- Whois Helpers -------------

  # Perform Whois lookup and return the record
  def lookup(str)
    begin
      Whois.whois(str).to_s
    rescue Whois::ServerNotFound
      begin
        tld = PublicSuffix.parse(str).tld
      rescue PublicSuffix::DomainInvalid
        raise "\"#{str}\" is not a valid entry"
      end
      whois_server(tld).lookup(str).to_s
    end
  end

  # Get Whois server for the given TLD
  def whois_server(tld)
    return Whois::Server.factory :tld, ".nyc", "whois.nic.nyc" if tld == "nyc"
    host = Whois.whois(".#{tld}").match(/whois.+/).to_s.split.last
    raise "Unable to find a WHOIS server for .#{tld.upcase}" unless host
    Whois::Server.factory :tld, ".#{tld}", host
  end

  #------------- Maintenance Alerts Helpers -------------

  # Parse eNom maintenance from http://www.enom.com/registrynews.asp
  def parse_alerts
    alerts = []
    maintenance_page = Nokogiri::HTML(open("http://www.enom.com/registrynews.asp"))
    maintenance_page.css('div.sCnt3.sFL').css('table').each do |table|
      alert = {}
      # Parse TLD (the left column)
      alert[:tlds] = "." + table.css('tbody').css('tr').css('td')[0].text.upcase
      # Parse message (the right column)
      alert[:message] = table.css('tbody').css('tr').css('td')[1].text
      # Extract :tlds from the message if needed
      alert[:tlds] = /.+and\s\.\w+/.match(alert[:message]).to_s if alert[:message] =~ /and\s\.\w+/
      alerts << alert
    end
    alerts
  end


end
