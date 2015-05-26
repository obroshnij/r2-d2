class DomainBoxController < ApplicationController

  def whois
  end

  def whois_lookup
    begin
      @record = R2D2::Whoiz.lookup params[:name]
    rescue Exception => ex
      flash.now[:alert] = "Error: #{ex.message}"
    end
    render action: :whois
  end

  def parse_domains
  end

  def perform_parsing
    hash = R2D2::Parser.parse_domains(params.permit(:text, :remove_subdomains, :count_tlds, :count_duplicates))
    @domains = hash[:domains]
    @tlds_count = hash[:tlds_count]
    @duplicates_count = hash[:duplicates_count]
    render action: :parse_domains
  end

  def bulk_dig
  end

  def perform_bulk_dig
    resolver = R2D2::DNS::Resolver.new(type: params[:ns])
    host_names = params[:query].downcase.split
    record_types = params[:record_types] ? params[:record_types] : [:a, :mx, :ns]
    @result = host_names.each_with_object(Array.new) do |host, array|
      hash = Hash["Host Name", [host]]
      record_types.each do |record|
        hash[record.to_s.upcase] = resolver.dig(host: host, record: record)
      end
      array << hash
    end
    render action: :bulk_dig
  rescue Exception => ex
    flash.now[:alert] = "Error: #{ex.message}"
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