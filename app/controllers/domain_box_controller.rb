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
    @list_one      = params[:list_one].split("\r\n").map(&:strip).map(&:downcase)
    @list_two      = params[:list_two].split("\r\n").map(&:strip).map(&:downcase)
    @list_one_dup  = @list_one.select { |el| @list_one.count(el) > 1 }.uniq
    @list_two_dup  = @list_two.select { |el| @list_two.count(el) > 1 }.uniq
    @list_one_only = @list_one - @list_two
    @list_two_only = @list_two - @list_one
    @unique        = (@list_one + @list_two).uniq
    @common        = @unique.select { |el| @list_one.include?(el) && @list_two.include?(el) }
    render action: :compare_lists
  end
  
  def unauthorized
    render text: request.inspect, status: 403
  end

end