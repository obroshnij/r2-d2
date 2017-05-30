namespace :whois do

  desc 'Check which TLDs haven not been covered by Whois Parser tests'
  task :coverage do
    whois_definitions = File.open('lib/whois_definitions.json') { |f| JSON.parse(f.read) }
    tests = File.open('spec/models/whois_parser_spec.rb') { |f| f.read }
    whois_definitions.keys.each do |tld|
      puts '.' + tld.upcase + ' is not covered' unless tests.include?("parses correct properties for .#{tld.upcase} domains")
    end
  end

  desc 'Pull whois definitions from production server and update them locally'
  task :pull do
    server_defs = JSON.parse `ssh deployer@r2-d2.nmchp.com cat /var/www/apps/r2-d2/current/lib/whois_definitions.json`
    local_defs = File.open('lib/whois_definitions.json') { |f| JSON.parse(f.read) }
    File.open('lib/whois_definitions.json', "w") do |f|
      f.write JSON.generate(local_defs.merge(server_defs)).gsub(",", ",\n ")
    end
    diff = server_defs.keys - local_defs.keys
    puts "The following TLDs have been added:\n #{diff.map { |tld| '.' + tld.upcase }.join(', ')}" if diff.present?
  end

  desc 'Whois test domains and store the data in a JSON file'
  task :test => :environment do
    domains, whois_data = [], {}
    File.open File.join(Rails.root, 'spec', 'models', 'whois_parser_spec.rb') do |f|
      domains = DomainName.parse_multiple(f.read.scan(/u?n?registered\ =.+/).join(' ')).map(&:name).uniq
    end
    until domains.empty? do
      domains.each do |name|
        begin
          whois_data[name] = Whois.lookup name
          domains -= [name]
        rescue
          next
        end
      end
      puts 'Unable to lookup ' + domains.join(', ') + '. Trying again...' unless domains.empty?
    end
    f = File.new File.join(Rails.root, 'spec', 'test_whois_data.json'), 'w'
    f.write JSON.generate(whois_data).gsub("\",\"", "\",\n\"")
    f.close
  end

end
