module DomainBoxHelper
  
  def domain_list(domains, sort_by_tld = false)
    domains ||= []
    domains = sort_by_tld.present? ? domains.sort { |one, two| one.tld <=> two.tld } : domains
    domains.map(&:name).join("\n")
  end
  
  def count_tlds(domains)
    domains.each_with_object(Hash.new(0)) { |domain, hash| hash[domain.tld] += 1 }.sort_by { |key, value| value }.reverse
  end
  
  def count_duplicates(domains)
    domains.select { |domain| domain.extra_attr[:occurrences_count] > 1 }
  end

end