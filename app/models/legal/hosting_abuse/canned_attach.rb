class Legal::HostingAbuse::CannedAttach

  def initialize hosting_abuse
    @abuse    = hosting_abuse
    @template = get_template
  end

  def render format
    return nil unless @template
    renderer = get_renderer(format).new
    renderer.render render_template
  end

  def present?
    @template.present?
  end

  def name
    user = if @abuse.service_id == 2 # Reseller Hosting
      @abuse.resold_username || @abuse.username
    else
      @abuse.username
    end

    "#{get_prefix}_#{user}_#{Time.zone.now.strftime('%b-%d-%Y')}"
  end

  private

  def get_prefix
    return 'Disk_Abuse'     if get_template_name == 'resource_abuse_disc.txt.erb'
    return 'Resource_Abuse' if get_template_name == 'resource_abuse_lve.txt.erb'
    return 'DDoS_Log'       if get_template_name == 'ddos_inbound.txt.erb'
    return 'DDoS_Log'       if get_template_name == 'ddos_shared_reseller.txt.erb'
    return 'Email_Abuse'    if get_template_name == 'spam.txt.erb'
    return 'Email_Abuse'    if get_template_name == 'pe_spam.txt.erb'
    'Blank'
  end

  def get_renderer format
    return Legal::HostingAbuse::CannedAttach::Txt if format == :txt
    return Legal::HostingAbuse::CannedAttach::Pdf if format == :pdf
  end

  def render_template
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
    if @abuse.type.name == 'Resource Abuse'
      return nil                            if @abuse.service.name == 'Private Email'

      return 'resource_abuse_lve.txt.erb'   if @abuse.resource.type.name == 'LVE / MySQL'
      return 'resource_abuse_disc.txt.erb'  if @abuse.resource.type.name == 'Disk Space'
    end

    if @abuse.type.name == 'DDoS'
      return 'ddos_shared_reseller.txt.erb' if ["Shared Hosting", "Reseller Hosting"].include?(@abuse.service.name) && [1, 2, 3].include?(@abuse.ddos.block_type_id)
      return 'ddos_inbound.txt.erb'         if (@abuse.ddos.inbound == true || @abuse.ddos.inbound.nil?)            && [1, 2, 3].include?(@abuse.ddos.block_type_id)
    end

    if @abuse.spam && @abuse.spam.header && @abuse.spam.body
      return 'spam.txt.erb'
    end

    if @abuse.pe_spam && @abuse.pe_spam.header && @abuse.pe_spam.body
      return 'pe_spam.txt.erb'
    end

    nil
  end

  def templates_folder_path
    File.join Rails.root, 'app', 'models', 'legal', 'hosting_abuse', 'canned_attach', 'templates'
  end

end
