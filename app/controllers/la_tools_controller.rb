class LaToolsController < ApplicationController

  before_action :authenticate_user!

  def new
  end

  def parse
    hash = R2D2::Parser.parse_domains(params.permit(:text, :count_occurrences, :remove_subdomains))
    @occurrences_count = hash[:occurrences_count]
    @domains = hash[:domains]
    render action: :new
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
    checkers = [R2D2::DNS::DBL.new, R2D2::DNS::SURBL.new]
    if params[:use_cache]
      cache = get_cache
      cache.each do |hash|
        checkers.each { |checker| hash[checker.type.downcase.to_sym] = checker.listed?(hash[:domainname]) ? "YES" : "NO" }
      end
      cache(cache)
      redirect_to action: :show_cache
    else
      domains = params[:query].downcase.split
      @result = domains.each_with_object(Array.new) do |domain, array|
        hash = Hash[:domainname, domain]
        checkers.each { |checker| hash[checker.type.downcase.to_sym] = checker.listed?(domain) ? "YES" : "NO" }
        array << hash
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