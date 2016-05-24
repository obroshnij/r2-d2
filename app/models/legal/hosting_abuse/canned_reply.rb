class Legal::HostingAbuse::CannedReply
  
  def initialize hosting_abuse
    @abuse    = hosting_abuse
    @template = get_template
  end
  
  def canned
    @canned ||= render
  end
  
  def uber_note
    return nil unless canned
    return "Ticket ID is required to generate a note" unless @abuse.ticket_id.present?
    uber_note_header + canned.lines.first.strip
  end
  
  private
  
  def reseller_username
    return @abuse.resold_username if @abuse.resold_username.present?
    @abuse.username
  end
  
  def pe_domain
    return nil unless @abuse.service.name == 'Private Email'
    domain = DomainName.parse_multiple(@abuse.subscription_name.to_s).first
    domain.present? ? domain.name : 'xDOMAINx'
  end
  
  def pe_username
    return nil unless @abuse.service.name == 'Private Email'
    username = @abuse.nc_user.try(:username)
    username.present? ? username : 'xUSERNAMEx'
  end
  
  def if_ip_is_blacklisted text
    return nil unless @abuse.type_id == 1
    ip_is_blacklisted? ? "#{text}" : ""
  end
  
  def ip_is_blacklisted?
    ip_is_blacklisted = @abuse.spam.ip_is_blacklisted
    ip_is_blacklisted = nil if ip_is_blacklisted == 'N/A'
    ip_is_blacklisted || @abuse.spam.reported_ip_blacklisted
  end
  
  def blacklisted_ip
    @abuse.spam.blacklisted_ip.try(:split).try(:join, ' | ') || @abuse.spam.reported_ip.try(:split).try(:join, ' | ')
  end
  
  def ddos_target_domains
    return nil unless @abuse.type_id == 3
    parse_domains @abuse.ddos.domain_port
  end
  
  def spam_domains
    return nil unless @abuse.type_id == 1
    parse_domains @abuse.spam.involved_mailboxes
  end
  
  def parse_domains text
    text ||= ""
    domains = DomainName.parse_multiple(text).map(&:name).join(" | ")
    domains.present? ? " (#{domains}) " : " "
  end
  
  def suspended?
    [4, 5, 7].include? @abuse.suggestion_id
  end
  
  def uber_note_header
    service_id = @abuse.uber_service.try(:identifier).try(:strip).present? ? @abuse.uber_service.identifier : 'XXXXXXXX'
    header =  "================= ABUSE =================\n\n"
    header << "Service ID #{service_id}\n\n"
    header << @abuse.created_at.strftime('%b/%d/%Y')
    header << "\n#{@abuse.ticket.identifier} - "
  end
  
  def render
    @template.try :result, binding
  end
  
  def get_template
    if template_path = get_template_path
      ERB.new File.open(template_path).read, nil, '<->'
    end
  end
  
  def get_template_path
    if template_name = get_template_name
      File.join templates_folder_path, template_name
    end
  end
  
  def get_template_name
    return nil if @abuse.service.name == 'Email Forwarding'
    
    if @abuse.type.name == 'Email Abuse / Spam'
      return 'spam_shared_reseller.txt.erb' if ["Shared Hosting", "Reseller Hosting"].include?(@abuse.service.name)
      return 'pe_spam.txt.erb'              if @abuse.service.name == 'Private Email'
      return 'spam_vps_suspended.txt.erb'   if suspended?
      return 'spam_vps.txt.erb'             unless suspended?
    end
    
    if @abuse.type.name == 'Resource Abuse'
      return nil                            if @abuse.service.name == 'Private Email'
      return 'resource_abuse_lve.txt.erb'   if @abuse.resource.type.name == 'LVE / MySQL'
      return 'resource_abuse_cron.txt.erb'  if @abuse.resource.type.name == 'Cron Jobs'
      return 'resource_abuse_disc.txt.erb'  if @abuse.resource.type.name == 'Disk Space'
    end
    
    if @abuse.type.name == 'DDoS'
      return 'ddos_shared_reseller.txt.erb' if ["Shared Hosting", "Reseller Hosting"].include?(@abuse.service.name)
      return 'ddos_inbound.txt.erb'         if @abuse.ddos.inbound == true || @abuse.ddos.inbound.nil?
      return 'ddos_outbound.txt.erb'        if @abuse.ddos.inbound == false
    end
  end
  
  def templates_folder_path
    File.join Rails.root, 'app', 'models', 'legal', 'hosting_abuse', 'canned_reply'
  end
  
end