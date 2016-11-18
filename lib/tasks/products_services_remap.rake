namespace :products do

  desc 'Create single product instead of multiple SSL products and remap assigned services'
  task remap: :environment do
    ids = [4, 5, 6]

    Rake::Task['products:create_ssl_with_services'].invoke
    Domains::Compensation::NamecheapProduct.where(id: ids).map(&:destroy)
    Domains::Compensation::NamecheapService.where(product_id: ids).map(&:destroy)
    Domains::Compensation.where(product_id: ids).each { |c| c.update_attribute(:affected_product_id, c.product_id) }
  end

  task create_ssl_with_services: :environment do

    ssl = Domains::Compensation::NamecheapProduct.find_or_create_by(name: 'SSL')

    [
      "PositiveSSL",
      "EssentialSSL",
      "PositiveSSL Wildcard",
      "EssentialSSL Wildcard",
      "PositiveSSL Multi-Domain",
      "InstantSSL",
      "InstantSSL Pro",
      "PremiumSSL",
      "PremiumSSL Wildcard",
      "Unified Communications",
      "Multi-Domain SSL",
      "EV SSL",
      "EV Multi-Domain SSL"
    ].each do |name|
      Domains::Compensation::NamecheapService.find_or_create_by(name: name, product_id: ssl.id)
    end

  end


  task create_affected_products: :environment do
    [
        "Domains",
        "Hosting",
        "NCPE",
        "SSL (Namecheap.com)",
        "SSL (SSLs.com)",
        "SSLcertificate.com",
        "WhoisGuard",
        "PremiumDNS",
        "Apps",
        "Credit (funds added to account balance)"
    ].each do |name|
      Domains::Compensation::AffectedProduct.find_or_create_by(name: name)
    end

  end

end
