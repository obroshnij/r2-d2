class WhoisController < ApplicationController
  def new
  end

  def create
  	@record = lookup params[:name].strip
  	render 'new'
  rescue Exception => ex
  	flash.now[:alert] = "Error: #{ex.message}"
    render 'new'
  end

  private

  def lookup(str)
    begin
      Whois.whois(str).to_s
    rescue Whois::ServerNotFound
      begin
        tld = PublicSuffix.parse(str).tld
      rescue PublicSuffix::DomainInvalid
        raise "\"#{str}\" is not a valid entry"
      end
      whois_server(tld).lookup(PublicSuffix.parse(str)).to_s
    end
  end

  def whois_server(tld)
    return Whois::Server.factory :tld, ".nyc", "whois.nic.nyc" if tld == "nyc"
    host = Whois.whois(".#{tld}").match(/whois.+/).to_s.split.last
    raise "Unable to find a WHOIS server for .#{tld.upcase}" unless host
    Whois::Server.factory :tld, ".#{tld}", host
  end

end
