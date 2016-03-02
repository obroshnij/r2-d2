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
    uber_note_header + "\n" + canned.lines.first.strip
  end
  
  private
  
  def if_ip_is_blacklisted text
    return nil unless @abuse.type_id == 1
    ip_is_blacklisted? ? "#{text}" : ""
  end
  
  def ip_is_blacklisted?
    @abuse.spam.ip_is_blacklisted || @abuse.spam.reported_ip_blacklisted
  end
  
  def blacklisted_ip
    @abuse.spam.blacklisted_ip || @abuse.spam.reported_ip
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
    header =  "================= ABUSE =================\n\n"
    header << "Service ID #{@abuse.uber_service.try(:identifier) || 'XXXXXXXX'}\n\n"
    header << @abuse.created_at.strftime('%b/%d/%Y')
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
    return nil if ["Private Email", "Email Forwarding"].include?(@abuse.type.name)
    
    if @abuse.type.name == 'Email Abuse / Spam'
      return 'spam_shared_reseller.txt.erb' if ["Shared Hosting", "Reseller Hosting"].include?(@abuse.service.name)
      return 'spam_vps_suspended.txt.erb'   if suspended?
      return 'spam_vps.txt.erb'             unless suspended?
    end
    
    if @abuse.type.name == 'Resource Abuse'
      return 'resource_abuse_lve.txt.erb'   if @abuse.resource.type.name == 'LVE / MySQL'
      return 'resource_abuse_cron.txt.erb'  if @abuse.resource.type.name == 'Cron Jobs'
      return 'resource_abuse_disc.txt.erb'  if @abuse.resource.type.name == 'Disc Space'
    end
    
    if @abuse.type.name == 'DDoS'
      return 'ddos_shared_reseller.txt.erb' if ["Shared Hosting", "Reseller Hosting"].include?(@abuse.service.name)
      return 'ddos_inbound.txt.erb'         if @abuse.ddos.inbound
      return 'ddos_outbound.txt.erb'        unless @abuse.ddos.inbound
    end
  end
  
  def templates_folder_path
    File.join Rails.root, 'app', 'models', 'legal', 'hosting_abuse', 'canned_reply'
  end
  
end