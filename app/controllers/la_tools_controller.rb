class LaToolsController < ApplicationController

  before_action :authenticate_user!

  def new
  end

  def parse
    query = extract_host_names(params[:query])
    domains = parse_valid_domains(query)
    @occurrences_count = count_occurrences(domains)
    @domains = domains.uniq.inject("") { |result, domain| result + "#{domain}\n" }.chomp
    render 'new'
  end

  def append_csv
    domains_count = Hash[*params[:domains_count].split]
    csv = parse_domains_info(params[:domains_info])
    result = []
    csv.each do |line|
      hash = { domainname: line[:domainname], count: domains_count[line[:domainname]] }
      params[:csv_options].each { |option| hash[option.to_sym] = line[option.to_sym] }
      result << hash
    end
    cache(result)
    redirect_to action: :show_cache
  end

  def show_cache
    @cache = get_cache
  end

  def dbl_surbl
  end

  def dbl_surbl_check
    dbl, surbl = DblChecker.new, SurblChecker.new
    if params[:use_cache]
      cache = get_cache
      cache.each do |hash|
        hash[:dbl] = dbl.listed?(hash[:domainname]) ? "YES" : "NO"
        hash[:surbl] = surbl.listed?(hash[:domainname]) ? "YES" : "NO"
      end
      cache(cache)
      redirect_to action: :show_cache
    else
      @result = []
      domains = params[:query].downcase.split
      domains.each do |domain|
        hash = {}
        hash[:domainname] = domain
        hash[:dbl] = dbl.listed?(domain) ? "YES" : "NO"
        hash[:surbl] = surbl.listed?(domain) ? "YES" : "NO"
        @result << hash
      end
      @domains = domains.join("\n")
      render action: :dbl_surbl
    end
  rescue Exception => ex
    flash.now[:alert] = "Error: #{ex.message}"
    render action: :dbl_surbl
  end

  def cache_dbl_surbl
    cache = get_cache.delete_if { |hash| hash[:dbl] == "NO" && hash[:surbl] == "NO" }
    usernames = cache.collect { |hash| hash[:username] }.uniq
    @result = []
    usernames.each do |username|
      hash = Hash[:username, username]
      hash[:email] = cache[cache.find_index { |hash| hash[:username] == username }][:email]
      hash[:domains] = cache.collect { |hash| hash[:domainname] if hash[:username] == username }.compact
      hash[:vip_domains] = hash[:domains].collect { |domain| domain if vip_domain?(domain) }.compact
      hash[:domains] -= hash[:vip_domains]
      @result << hash
    end
  end

end