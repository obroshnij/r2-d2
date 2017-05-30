namespace :dns do

  desc "Update DBL and SURBL nameservers list"
  task update_blacklist_dns: :environment do
    [DNS::DBL, DNS::SURBL].each do |klass|
      nameservers = get_nameservers(klass)

      path = File.join(Rails.root, "lib/dns/#{klass.to_s.demodulize.downcase}_ns.json")

      File.open(path, "w") do |f|
        f.write JSON.pretty_generate(nameservers)
      end
    end
  end

  desc "Pull DBL and SURBL nameservers list from production server"
  task :pull do
    dbl   = JSON.parse `ssh deployer@r2-d2.nmchp.com cat /var/www/apps/r2-d2/current/lib/dns/dbl_ns.json`
    surbl = JSON.parse `ssh deployer@r2-d2.nmchp.com cat /var/www/apps/r2-d2/current/lib/dns/surbl_ns.json`

    File.open('lib/dns/dbl_ns.json',   'w') { |f| f.write JSON.pretty_generate(dbl) }
    File.open('lib/dns/surbl_ns.json', 'w') { |f| f.write JSON.pretty_generate(surbl) }
  end

  def get_nameservers klass
    resolver = DNS::Resolver.new

    nameservers = resolver.dig(klass.base_host, record: :ns)
    nameservers = klass.backup_nameservers if nameservers.blank?

    ips = nameservers.map { |ns| resolver.dig(ns, record: :a) }.flatten
    ips.keep_if { |ip| klass.valid_nameserver?(ip) }
  end

end
