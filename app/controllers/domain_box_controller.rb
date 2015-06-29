class DomainBoxController < ApplicationController

  def whois
  end

  def whois_lookup
    begin
      @record = Whois.lookup params[:name].strip.downcase
    rescue Exception => ex
      flash.now[:alert] = "Error: #{ex.message}"
    end
    render action: :whois
  end

  def parse_domains
  end

  def perform_parsing
    @domains = DomainName.parse_multiple params[:text], remove_subdomains: params[:remove_subdomains].present?
    render action: :parse_domains
  end

  def bulk_dig
  end

  def perform_bulk_dig
    @domains = DomainName.parse_multiple params[:query]
    records = params[:record_types].present? ? params[:record_types] : [:a, :mx, :ns]
    DNS::Resolver.dig_multiple @domains, type: params[:ns].to_sym, records: records
    render action: :bulk_dig
  end

  def compare_lists
  end

  def perform_comparison
    list_one, list_two = params[:list_one].downcase.split, params[:list_two].downcase.split
    @result = list_one.each_with_object(Array.new) { |domain, array| array << domain unless list_two.include?(domain) }.join("\n")
    @list_one = list_one.join("\n")
    @list_two = list_two.join("\n")
    render action: :compare_lists
  end
  
  def unauthorized
    render text: request.inspect, status: 403
  end

end