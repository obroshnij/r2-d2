class DomainBoxController < ApplicationController

  def new
  end

  def create
    query = extract_host_names(params[:query])
    domains = params[:remove_subdomains] ? parse_valid_domains(query) : parse_valid_subdomains(query)
    @tlds_count = count_tlds(domains) if params[:count_tlds]
    @duplicates_count = count_duplicates(domains) if params[:count_duplicates]
    @occurrences_count = count_occurrences(domains) if params[:count_occurrences]
    @domains = domains.uniq.inject("") { |result, domain| result + "#{domain}\n" }.chomp
    render 'new'
  end

  def export
    redirect_to action: 'new'
  end

  def parse
    domains_count = Hash[*params[:domains_count].split]
    csv = parse_domains_info(params[:domains_info])
    @result = []
    csv.each do |line|
      hash = { domainname: line[:domainname], count: domains_count[line[:domainname]] }
      params[:csv_options].each { |option| hash[option] = line[option.to_sym] }
      @result << hash
    end
    render 'parse'
  end

end