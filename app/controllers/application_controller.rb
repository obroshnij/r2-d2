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

end
