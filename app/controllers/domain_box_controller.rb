class DomainBoxController < ApplicationController

  def new
  end

  def create
    query = params[:query].scan(/(?:[a-z0-9\-]+\.)*(?:(?:xn--)?(?:[a-z0-9]+\-)*[a-z0-9]+\.)+[a-z]+/ix)
    domains = []

    query.each do |domain|
      domain.downcase!
      if PublicSuffix.valid?(domain)
        if params[:remove_subdomains]
          domains << PublicSuffix.parse(domain).domain
        else
          domains << (PublicSuffix.parse(domain).subdomain ? PublicSuffix.parse(domain).subdomain : PublicSuffix.parse(domain).domain)
        end
      end
    end

    if params[:count_occurrences]
      occurrences_count = domains.each_with_object(Hash.new(0)) { |domain, hash| hash[domain] += 1 }
      @occurrences_count = occurrences_count.sort_by { |key, value| value }.reverse
    end

    if params[:count_tlds]
      tlds_count = domains.uniq.each_with_object(Hash.new(0)) { |domain, hash| hash[PublicSuffix.parse(domain).tld] += 1 }
      @tlds_count = tlds_count.sort_by { |key, value| value }.reverse
    end

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