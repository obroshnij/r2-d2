module LaToolsHelper

  # Parse the CSV file + replace firstanme and lastname with full name
  def parse_domains_info(csv_file)
    mapping = { domainname: :domain_name, lasttransaction: :last_transaction, expire_datetime: :expiration_date,
              email: :email_address, user_createdatetime: :signup_date, lastlogin: :last_login, orderid: :order_id }
    csv = SmarterCSV.process(csv_file, strip_chars_from_headers: /'/, key_mapping: mapping)
    csv.each do |hash|
      hash[:full_name] = [hash[:firstname], hash[:lastname]].join(" ")
      hash.delete(:firstname); hash.delete(:lastname)
    end
    csv
  end
  
  # Generate CSV file
  def generate_csv(array)
    headers = array.first.attributes.keys - %w{id user_id created_at updated_at}
    csv = ""
    headers.each { |header| csv << "#{header.titleize}," }
    csv << "\n"
    array.each do |hash|
      headers.each do |header|
        csv << "\"#{hash[header].to_s}\","
      end
      csv << "\n"
    end
    csv
  end
  
  ####################################################################################################
  # The following methods accept arrays of hashes and append additional key-value pair(s) to each hash
  
  # Appends :dbl, :surbl and :blacklisted keys; possible values: true, false
  def dbl_surbl_bulk_check(array)
    checkers = [R2D2::DNS::DBL.new, R2D2::DNS::SURBL.new]
    array.each do |hash|
      checkers.each { |checker| hash[checker.type.downcase.to_sym] = checker.listed?(hash[:domain_name]) }
      hash[:blacklisted] = hash[:dbl] || hash[:surbl] ? true : false
    end
  end
  
  # Appends :epp_status and :nameservers keys; example value: "clientTransferProhibited, addPeriod", "ns1.p18.dynect.net, ns2.p18.dynect.net"
  def epp_status_bulk_check(array)
    array.each { |hash| hash[:epp_status] = R2D2::Whoiz.epp_status(hash[:domain_name]).join(", ") }
    array.each { |hash| hash[:nameservers] = R2D2::Whoiz.nameservers(hash[:domain_name]).join(", ") }
  end
  
  # Appends :ns_record, :a_record and :mx_record keys; example value: "dns1.namecheaphosting.com, dns2.namecheaphosting.com"
  def dns_bulk_check(array)
    resolver = R2D2::DNS::Resolver.new(type: :default)
    array.each do |hash|
      if hash[:epp_status].downcase.include?("hold")
        hash[:ns_record], hash[:a_record], hash[:mx_record] = "", "", ""
      else
        if hash[:nameservers].include?("dummysecondary.pleasecontactsupport.com")
          hash[:ns_record] = resolver.dig(host: hash[:domain_name], record: :ns).join(" ").gsub(". ", ", ").chomp(".")
          hash[:a_record], hash[:mx_record] = "", ""
        else
          hash[:ns_record] = resolver.dig(host: hash[:domain_name], record: :ns).join(" ").gsub(". ", ", ").chomp(".")
          hash[:a_record] = resolver.dig(host: hash[:domain_name], record: :a).join(" ").gsub(". ", ", ").chomp(".")
          hash[:mx_record] = resolver.dig(host: hash[:domain_name], record: :mx).join(" ").gsub(". ", ", ").chomp(".")
        end
      end
    end
  end
  
  # Appends :vip_domain, :has_vip_domains and :spammer keys; possible values: true, false
  def internal_lists_bulk_check(array)
    array.each do |hash|
      hash[:vip_domain] = vip_domain? hash[:domain_name]
      hash[:has_vip_domains] = has_vip_domains? hash[:username]
      hash[:spammer] = spammer? hash[:username]
    end
  end
  
  # Appends :suspended_by_registry, :suspended_by_enom, :suspended_by_namecheap, :suspended_for_whois, :expired and :inactive keys; possible values: true, false
  def suspension_bulk_check(array)
    array.each do |hash|
      hash[:suspended_by_registry] = false; hash[:suspended_by_namecheap] = false; hash[:suspended_by_enom] = false; hash[:expired] = false; hash[:suspended_for_whois] = false; hash[:inactive] = false
      
      hash[:suspended_by_registry] = true if hash[:epp_status].downcase.split(", ").include? "hold"
      hash[:suspended_by_registry] = true if hash[:epp_status].downcase.split(", ").include? "serverhold"
      hash[:suspended_by_registry] = true if hash[:epp_status].downcase.split(", ").include?("serverrenewprohibited") && hash[:epp_status].downcase.split(", ").include?("serverdeleteprohibited") && hash[:epp_status].downcase.split(", ").include?("serverupdateprohibited")
      
      hash[:suspended_by_enom] = true if hash[:epp_status].downcase.split(", ").include?("clienthold")
      
      hash[:suspended_by_namecheap] = true if hash[:nameservers].include? "dummysecondary.pleasecontactsupport.com"
      hash[:suspended_by_namecheap] = true if hash[:nameservers].include? "dns101.registrar-servers.com"
      
      unless hash[:a_record].blank?
        hash[:expired] = true if hash[:nameservers].include?("name-services.com") && IPAddress("64.74.223.1/24").network.include?(IPAddress(hash[:a_record])) || IPAddress("8.5.1.1/24").network.include?(IPAddress(hash[:a_record]))
        hash[:suspended_for_whois] = true if hash[:nameservers].include?("name-services.com") && hash[:a_record] == "98.124.253.216"
      end
      
      hash[:inactive] = true if hash[:suspended_by_registry] || hash[:suspended_by_enom] || hash[:suspended_by_namecheap] || hash[:expired] || hash[:suspended_for_whois]
    end
  end

  ####################################################################################################
  
  # Checks if the domain is VIP
  def vip_domain?(domain)
    VipDomain.find_by(domain: domain.try(:downcase)) ? true : false
  end
  
  # Checks if the user has VIP domains
  def has_vip_domains?(username)
    VipDomain.find_by(username: username.try(:downcase)) ? true : false
  end

  # Checks if the user is blacklisted internally (spammer)
  def spammer?(username)
    Spammer.find_by(username: username.try(:downcase)) ? true : false
  end

  # Used in views to highlight table rows
  def color(hash)
    return "red" if Spammer.find_by(username: hash[:username].try(:downcase))
    return "blue" if VipDomain.find_by(domain: hash[:domain_name].try(:downcase))
    ""
  end

end