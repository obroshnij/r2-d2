module LaToolsHelper

  def cache(data)
    current_user.update_attributes(cache: data.to_json) ? flash[:notice] = "Data has been successfully cached" : flash[:alert] = "Something went wrong"
  end

  def get_cache
    JSON.parse(current_user.cache, symbolize_names: true)
  end

  # Parse the CSV file + replace firstanme and lastname with fullname
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

  def dbl_surbl_bulk_check(array)
    checkers = [R2D2::DNS::DBL.new, R2D2::DNS::SURBL.new]
    array.each do |hash|
      checkers.each { |checker| hash[checker.type.downcase.to_sym] = checker.listed?(hash[:domain_name]) ? "YES" : "NO" }
    end
  end

  def epp_status_bulk_check(array)
    array.each { |hash| hash[:epp_status] = R2D2::Whoiz.epp_status(hash[:domain_name]).join(", ") }
  end

  def dns_bulk_check(array)
    resolver = R2D2::DNS::Resolver.new(type: :default)
    array.each do |hash|
      hash[:ns_record] = resolver.dig(host: hash[:domain_name], record: :ns).join(" ")
      hash[:a_record] = resolver.dig(host: hash[:domain_name], record: :a).join(" ")
    end
  end

  def color(hash)
    return "red" if Spammer.find_by(username: hash[:username].try(:downcase))
    return "blue" if VipDomain.find_by(domain: hash[:domain_name].try(:downcase))
    ""
  end

  def vip_domain?(domain)
    VipDomain.find_by(domain: domain.try(:downcase)) ? true : false
  end

  def spammer?(username)
    Spammer.find_by(username: username.try(:downcase)) ? true : false
  end

  def transform_dbl_array(array)
    domains = array.collect { |hash| hash[:domain_name] if !vip_domain?(hash[:domain_name]) && hash[:dbl] == "YES" || hash[:surbl] == "YES" }.compact
    Hash[:domains, domains]
  end

  def get_canned_reply(data)
    reply = nil
    # DBL/SURBL check with no cache -> no username
    if data[:dbl] && !data[:username]
      # VIP domain?
      if vip_domain?(data[:domain_name])
        reply = CannedReply.find_by(name: "dbl_surbl/vip_domain")
      else
        reply = CannedReply.find_by(name: "dbl_surbl/to_client")
      end
    # DBL/SURBL check using cache
    elsif data[:domains]
      if spammer?(data[:username])
        reply = CannedReply.find_by(name: "dbl_surbl/to_spammer")
      else
        reply = CannedReply.find_by(name: "dbl_surbl/to_client")
      end
    end
    substitute_domains(reply, data)
  end

  def substitute_domains(reply, data)
    if data[:domain_name]
      reply.body = reply.body.gsub("$domains$", data[:domain_name])
    elsif data[:domains]
      reply.body = reply.body.gsub("$domains$", data[:domains].join("\n"))
    end
    reply
  end

end