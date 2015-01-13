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
          hash[:ns_record] = resolver.dig(host: hash[:domain_name], record: :ns).join(", ")
          hash[:a_record], hash[:mx_record] = "", ""
        else
          hash[:ns_record] = resolver.dig(host: hash[:domain_name], record: :ns).join(", ")
          hash[:a_record] = resolver.dig(host: hash[:domain_name], record: :a).join(", ")
          hash[:mx_record] = resolver.dig(host: hash[:domain_name], record: :mx).join(", ")
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
      hash[:internal_account] = internal_account? hash[:username]
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
        hash[:expired] = true if hash[:nameservers].include?("name-services.com") && IPAddress("64.74.223.1/24").network.include?(IPAddress(hash[:a_record].split(", ").last)) || IPAddress("8.5.1.1/24").network.include?(IPAddress(hash[:a_record].split(", ").last))
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
  
  def internal_account?(username)
    InternalAccount.find_by(username: username.try(:downcase)) ? true : false
  end

  # Used in views to highlight table rows
  def color(hash)
    return "red" if hash[:spammer]
    return "blue" if hash[:has_vip_domains]
    return "green" if hash[:internal_account]
    ""
  end
  
  # TODO
  # Refactor the method below
  def transform_spam_data_for_owners(array)
    result = []
    array.collect { |domain| domain.username }.uniq.each do |username|
      hash = { username: username }
      hash[:email_address] = array.collect { |domain| domain.email_address if domain.username == username }.compact.first
      hash[:has_vip_domains] = array.collect { |domain| domain.has_vip_domains if domain.username == username }.compact.first
      hash[:spammer] = array.collect { |domain| domain.spammer if domain.username == username }.compact.first
      hash[:internal_account] = array.collect { |domain| domain.internal_account if domain.username == username }.compact.first
      hash[:blacklisted_domains] = array.collect { |domain| domain.domain_name if domain.username == username && domain.blacklisted }.compact
      hash[:not_blacklisted_domains] = array.collect { |domain| domain.domain_name if domain.username == username && !domain.blacklisted }.compact
      hash[:vip_domains] = array.collect { |domain| domain.domain_name if domain.username == username && domain.vip_domain }.compact
      hash[:already_suspended] = array.collect { |domain| domain.domain_name if domain.username == username && domain.suspended_by_namecheap }.compact
      hash[:dbl] = array.collect { |domain| domain.domain_name if domain.username == username && domain.dbl && !domain.surbl && !domain.suspended_by_namecheap }.compact
      hash[:dbl] = hash[:dbl].empty? ? nil : hash[:dbl]
      hash[:surbl] = array.collect { |domain| domain.domain_name if domain.username == username && !domain.dbl && domain.surbl && !domain.suspended_by_namecheap }.compact
      hash[:surbl] = hash[:surbl].empty? ? nil : hash[:surbl]
      hash[:dbl_surbl] = array.collect { |domain| domain.domain_name if domain.username == username && domain.dbl && domain.surbl && !domain.suspended_by_namecheap }.compact
      hash[:dbl_surbl] = hash[:dbl_surbl].empty? ? nil : hash[:dbl_surbl]
      hash[:suspended_by_registry] = array.collect { |domain| domain.domain_name if domain.username == username && domain.suspended_by_registry && !domain.suspended_by_namecheap }.compact
      hash[:suspended_by_registry] = hash[:suspended_by_registry].empty? ? nil : hash[:suspended_by_registry]
      result << hash
    end
    result
  end
  
  def get_canned_reply_for_spam_case(data)
    reply = {}
    count = data[:blacklisted_domains].count
    listing_count = (data[:dbl] && !data[:surbl] && !data[:dbl_surbl]) || (!data[:dbl] && data[:surbl] && !data[:dbl_surbl]) ? 1 : 2
    reply[:title] = "IMPORTANT: Spam report "
    reply[:title] += count > 1 ? "for your domains" : "for #{data[:blacklisted_domains].first} domain"
    
    reply[:body] = "Hello,\n\n"
    reply[:body] += "We regret to inform you that your " + "#{count > 1 ? "domains are" : "domain is"}" + " reported as involved into unsolicited email activity. "
    reply[:body] += "Generally domains involved into unsolicited email activities might be spamvertised (advertised via spam emails), "
    reply[:body] += "assigned to mailboxes or servers that are used to transmit spam emails. In other words recipients of such emails do not want to "
    reply[:body] += "receive them and refer to service providers and anti-spam organisations in order to stop the unsolicited mailing.\n\n"
    
    reply[:body] += "The following " + "#{count > 1 ? "domains of yours are" : "domain of yours is"}" + " marked by international trusted anti-spam " + "organisation".pluralize(listing_count) + ":\n\n"
    if data[:dbl]
      reply[:body] += "The Spamhaus Project Ltd. DBL:\n\n"
      data[:dbl].each { |domain| reply[:body] += domain + "\n" }
      reply[:body] += "\n"
    end
    if data[:surbl]
      reply[:body] += "SURBL:\n\n"
      data[:surbl].each { |domain| reply[:body] += domain + "\n" }
      reply[:body] += "\n"
    end
    if data[:dbl_surbl]
      reply[:body] += "Both Spamhaus DBL and SURBL Listings:\n\n"
      data[:dbl_surbl].each { |domain| reply[:body] += domain + "\n" }
      reply[:body] += "\n"
    end
    
    reply[:body] += "In order to monitor reputation of your domain at The Spamhaus Project Ltd. please refer to the DBL listing at http://www.spamhaus.org/lookup/\n" if data[:dbl] || data[:dbl_surbl]
    reply[:body] += "In order to monitor reputation of your domain at SURBL please refer to the SURBL listing at http://www.surbl.org/surbl-analysis/\n" if data[:surbl] || data[:dbl_surbl]
    reply[:body] += "\n"
    
    reply[:body] += "The fact that domains registered with Namecheap are blacklisted by trusted organisations affects reputation of our company. "
    reply[:body] += "Moreover, in accordance with Registration Agreement (at https://www.namecheap.com/legal/domains/registration-agreement.aspx ) signed by all "
    reply[:body] += "our customers upon creation of an account in our system, improper use of any services provided by Namecheap may result in service interruption.\n\n"
    
    unless data[:spammer]
      reply[:body] += "However, for you as our loyal customer we would like to provide the 48 hours grace period in order to get the " + "domain".pluralize(count)
      reply[:body] += " removed from the " + "listing".pluralize(listing_count) + ". If the " + "domain".pluralize(count) + " "
      reply[:body] += "#{count > 1 ? "remain" : "remains"}" + " blacklisted, we might be forced to suspend " + "#{count > 1 ? "them" : "it"}" + " to prevent further impact on our services.\n\n"
    end
    if data[:spammer]
      reply[:body] += "Unfortunately, due to persistent incidents of spam reported for your services with us we are forced to suspend the "
      reply[:body] += "domain".pluralize(count) + " until " + "#{count > 1 ? "they are" : "it is"}" + " removed form the " + "blacklist".pluralize(listing_count) + ".\n\n"
    end
    if data[:suspended_by_registry]
      reply[:body] += "Additionally it is revealed that the following " + "#{data[:suspended_by_registry].count > 1 ? "domains have" : "domain has"}"
      reply[:body] += " already been suspended by the Registry, to our regret:\n\n"
      data[:suspended_by_registry].each do |domain|
        reply[:body] += domain + "\n"
      end
      reply[:body] += "\nAs we are not in a position to dispute their decision we are forced to lock the " + "domain".pluralize(data[:suspended_by_registry].count)
      reply[:body] += " in our system until it is confirmed that Registry Hold is no longer applicable for " + "#{data[:suspended_by_registry].count > 1 ? "them" : "it"}" + ".\n\n"
    end
    if data[:spammer]
      reply[:body] += "Kindly let us know if there is any question."
    end
    unless data[:spammer]
      reply[:body] += "In order to avoid any confusion please let us once again emphasise that the reputation of your " + "domain".pluralize(count)
      reply[:body] += " must be improved during the next 48 hours in order to avoid any service interruption."
      if data[:suspended_by_registry]
        reply[:body] +=  " As for the " + "domain".pluralize(data[:suspended_by_registry].count) + " placed on hold, we will unlock "
        reply[:body] +=  "#{data[:suspended_by_registry].count > 1 ? "them" : "it"}" + " upon the confirmation of hold removal."
      end
      reply[:body] += "\n\nLooking forward to your reply."
    end
    
    reply
  end

end