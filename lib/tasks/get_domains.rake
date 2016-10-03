namespace :domains do
  desc "Grep all domain's name"
  task update_domain_names: :environment do
    page = Nokogiri::HTML(RestClient.get('https://www.namecheap.com/domains.aspx#domain_tab_pricing'))
    domain_elements = page.css('div.domain')
    domain_names_from_nc = domain_elements.map{ |page_element| page_element.children.children.first.to_s.tr('.*','') }.uniq

    domains_product = Domains::NamecheapProduct.find_by_name("Domains")
    domains = Domains::NamecheapService.where(domains_namecheap_product_id: domains_product.id)

    domain_names = domains.collect(&:name)

    deleted_domain_names  = domain_names - domain_names_from_nc
    new_domain_names = domain_names_from_nc - domain_names
    new_domain_names.each {|ndn| Domains::NamecheapService.create(name: ndn, domains_namecheap_product_id: domains_product.id) }
    domains.where(name: deleted_domain_names).each {|dn| dn.update_attribute(:hidden, true)}

  end

end
