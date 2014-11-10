class DomainBoxController < ApplicationController

  def new
  end

  def create
    query = extract_host_names(params[:query])
    domains = params[:remove_subdomains] ? parse_valid_domains(query) : parse_valid_subdomains(query)
    @tlds_count = count_tlds(domains)
    @duplicates_count = count_duplicates(domains)
    @domains = domains.uniq.inject("") { |result, domain| result + "#{domain}\n" }.chomp
    render 'new'
  end

  def bulk_dig
  end

  def perform_bulk_dig
    resolver = initialize_resolver(params[:ns])
    host_names = params[:query].downcase.split
    record_types = params[:record_types] ? params[:record_types] : ["a", "mx", "ns"]
    record_types = record_types.collect { |type| type.to_s.upcase }
    @result = Array.new
    host_names.each do |host|
      hash = Hash["Host Name", [host]]
      record_types.each do |rec|
        hash[rec] = []
        resolver.search(host, record_type(rec)).answer.each { |answer| hash[rec] << answer.value }
      end
      @result << hash
    end
    render action: :bulk_dig
  rescue Exception => ex
    flash.now[:alert] = "Error: #{ex.message}"
    render action: :bulk_dig
  end

end