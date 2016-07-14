module LaToolsHelper

  def row_color(nc_user)
    return 'red'   if nc_user.try(:status_names).try(:include?, 'Internal Spammer').present?
    return 'green' if nc_user.try(:status_names).try(:include?, 'Internal Account').present?
    return 'blue'  if nc_user.try(:status_names).try(:include?, 'Has VIP Domains').present? || nc_user.try(:status_names).try(:include?, 'VIP').present?
    ''
  end

  def icon_title(title)
    return content_tag(:i, '', class: 'fa fa-file-text-o inline')   if title == :blacklisted
    return content_tag(:i, '', class: 'fa fa-file-o inline')        if title == :not_blacklisted
    return content_tag(:i, '', class: 'fa fa-thumbs-down inline')   if title == :suspended_by_registry
    return content_tag(:i, '', class: 'fa fa-thumbs-o-down inline') if title == :suspended_by_enom
    return content_tag(:i, '', class: 'fa fa-terminal inline')      if title == :suspended_for_whois_verification
    return content_tag(:i, '', class: 'fa fa-lock inline')          if title == :suspended_by_namecheap
    return content_tag(:i, '', class: 'fa fa-clock-o inline')       if title == :expired
    return content_tag(:i, '', class: 'fa fa-recycle inline')       if title == :unregistered
  end

  def prettify_title(title)
    return 'Suspended by Registry (ServerHold)'  if title == :suspended_by_registry
    return 'Suspended by Registrar (ClientHold)' if title == :suspended_by_enom
    return 'Suspended by Namecheap (ParkingDNS)' if title == :suspended_by_namecheap
    title.to_s.titleize
  end

  def transform_job_data(data)
    result = {}
    data.each do |domain, val|
      val = val["extra_attr"]
      result[val["username"]] ||= {}
      user ||= result[val["username"]]

      user[:email_address]  = val["email_address"]

      [:vip, :active, :inactive, :blacklisted, :not_blacklisted,
       :suspended_by_registry, :suspended_by_enom, :suspended_for_whois_verification, :suspended_by_namecheap, :expired, :unregistered,
       :dbl, :surbl, :dbl_surbl].each do |sym|
        user[sym] ||= []
      end

      user[:vip]             << domain if      val["vip_domain"]
      user[:active]          << domain unless  val["inactive"]
      user[:inactive]        << domain if      val["inactive"]
      user[:blacklisted]     << domain if     !val["inactive"] && val["blacklisted"]
      user[:not_blacklisted] << domain if     !val["inactive"] && !val["blacklisted"]

      suspension_check user, domain, val

      user[:dbl]       << domain if val["dbl"]   && !val["surbl"] && !val["inactive"]
      user[:surbl]     << domain if val["surbl"] && !val["dbl"]   && !val["inactive"]
      user[:dbl_surbl] << domain if val["surbl"] &&  val["dbl"]   && !val["inactive"]
    end
    result
  end

  def suspension_check(user, domain, val)
    user[:suspended_by_registry]            << domain and return if val["suspended_by_registry"]
    user[:suspended_by_enom]                << domain and return if val["suspended_by_enom"]
    user[:suspended_for_whois_verification] << domain and return if val["suspended_for_whois"]
    user[:suspended_by_namecheap]           << domain and return if val["suspended_by_namecheap"]
    user[:expired]                          << domain and return if val["expired"]
    user[:unregistered]                     << domain and return if val["unregistered"]
  end

  def get_canned_reply_for_spam_case(nc_user, data)
    reply = {}
    data[:spammer] = nc_user.try(:status_names).try(:include?, 'Internal Spammer').present?
    count = data[:blacklisted].count
    listing_count = (data[:dbl] && !data[:surbl] && !data[:dbl_surbl]) || (!data[:dbl] && data[:surbl] && !data[:dbl_surbl]) ? 1 : 2

    reply[:title] = "IMPORTANT: Spam report "
    reply[:title] += count > 1 ? "for your domains" : "for #{data[:blacklisted].first} domain"

    reply[:body] = "Hello,\n\n"
    reply[:body] << "We regret to inform you that your " + "#{count > 1 ? "domains are" : "domain is"}" + " reported as involved in an unsolicited email activity.\n\n"
    reply[:body] << "FYI: Generally domains involved in unsolicited email activities might be spamvertised (advertised via spam emails), "
    reply[:body] << "assigned to mailboxes or servers that are used to transmit spam emails. In other words recipients of such emails do not want to "
    reply[:body] << "receive them and refer to service providers and anti-spam organisations in order to stop the unsolicited mailing.\n\n"

    reply[:body] << "The following " + "#{count > 1 ? "domains of yours are" : "domain of yours is"}" + " marked by international trusted anti-spam " + "organisation".pluralize(listing_count) + ":\n\n"
    if data[:dbl].present?
      reply[:body] << "The Spamhaus Project Ltd. DBL:\n\n"
      data[:dbl].each { |domain| reply[:body] << domain + "\n" }
      reply[:body] << "\n"
    end
    if data[:surbl].present?
      reply[:body] += "SURBL:\n\n"
      data[:surbl].each { |domain| reply[:body] += domain + "\n" }
      reply[:body] += "\n"
    end
    if data[:dbl_surbl].present?
      reply[:body] << "#{data[:dbl] && data[:surbl] ? "Both " : ""}Spamhaus DBL and SURBL Listings:\n\n"
      data[:dbl_surbl].each { |domain| reply[:body] << domain + "\n" }
      reply[:body] << "\n"
    end

    reply[:body] << "In order to monitor the reputation of your domain at The Spamhaus Project Ltd. please refer to the DBL listing at http://www.spamhaus.org/lookup/\n" if data[:dbl].present? || data[:dbl_surbl].present?
    reply[:body] << "In order to monitor the reputation of your domain at SURBL please refer to the SURBL listing at http://www.surbl.org/surbl-analysis/\n" if data[:surbl].present? || data[:dbl_surbl].present?
    reply[:body] << "\n"

    reply[:body] << "The fact that domains registered with Namecheap are blacklisted by the anti-spam organisations affects reputation of our company. "
    reply[:body] << "Moreover, in accordance with Registration Agreement (at https://www.namecheap.com/legal/domains/registration-agreement.aspx ) signed by all "
    reply[:body] << "our customers upon creation of an account in our system, improper use of any services provided by Namecheap may result in service interruption.\n\n"

    unless data[:spammer]
      reply[:body] << "However, for you as our loyal customer we would like to provide the 48 hours grace period in order to get the " + "domain".pluralize(count)
      reply[:body] << " removed from the " + "listing".pluralize(listing_count) + ". If the " + "domain".pluralize(count) + " "
      reply[:body] << "#{count > 1 ? "remain" : "remains"}" + " blacklisted, we might be forced to suspend " + "#{count > 1 ? "them" : "it"}" + " preventing further impact on our services.\n\n"
    end
    if data[:spammer]
      reply[:body] << "Unfortunately, due to persistent incidents of spam reported for your services with us we are forced to suspend the "
      reply[:body] << "domain".pluralize(count) + " until " + "#{count > 1 ? "they are" : "it is"}" + " removed from the " + "blacklist".pluralize(listing_count) + ".\n\n"
    end
    if data[:suspended_by_registry].present?
      reply[:body] << "Additionally it is revealed that the following " + "#{data[:suspended_by_registry].count > 1 ? "domains have" : "domain has"}"
      reply[:body] << " already been suspended by the Registry, to our regret:\n\n"
      data[:suspended_by_registry].each do |domain|
        reply[:body] << domain + "\n"
      end
      reply[:body] << "\nAs we are not in a position to dispute their decision we are forced to lock the " + "domain".pluralize(data[:suspended_by_registry].count)
      reply[:body] << " in our system until it is confirmed that Registry Hold is no longer applicable for " + "#{data[:suspended_by_registry].count > 1 ? "them" : "it"}" + ".\n\n"
    end
    if data[:spammer]
      reply[:body] << "Kindly let us know if there is any question."
    end
    unless data[:spammer]
      reply[:body] << "Please let us once again emphasise that the reputation of your " + "domain".pluralize(count)
      reply[:body] << " must be improved during the next 48 hours in order to avoid any service interruption."
      unless data[:suspended_by_registry].empty?
        reply[:body] <<  " As for the " + "domain".pluralize(data[:suspended_by_registry].count) + " placed on hold, we will unlock "
        reply[:body] <<  "#{data[:suspended_by_registry].count > 1 ? "them" : "it"}" + " upon the confirmation of the hold removal."
      end
      reply[:body] << "\n\nLooking forward to your reply."
    end

    reply
  end

  def linkify(url)
    url = (url[0..4].downcase == "http:" || url[0..5].downcase == "https:") ? url : "http://" + url
    "<a href=\"#{url}\">#{url}</a>".html_safe
  end

end
