namespace :domains do

  desc "Pull all available TLDs from Namecheap webiste"
  task update_domain_names: :environment do
    page = Nokogiri::HTML open('https://www.namecheap.com/domains.aspx#domain_tab_pricing')
    domain_elements = page.css('div.domain')
    domain_names_from_nc = domain_elements.map { |page_element| page_element.children.children.first.to_s.tr('*','') }.uniq.sort

    domains_product = Domains::Compensation::NamecheapProduct.find_by_name("Domains")
    domains         = Domains::Compensation::NamecheapService.where(product_id: domains_product.id)

    domain_names = domains.collect(&:name)

    deleted_domain_names = domain_names - domain_names_from_nc
    deleted_domain_names = deleted_domains.delete_if { |name| name =~ /coupon code/ }

    new_domain_names     = domain_names_from_nc - domain_names

    new_domain_names.each { |ndn| Domains::Compensation::NamecheapService.create(name: ndn, product_id: domains_product.id) }
    domains.where(name: deleted_domain_names).each { |dn| dn.update_attribute(:hidden, true) }
  end

end
