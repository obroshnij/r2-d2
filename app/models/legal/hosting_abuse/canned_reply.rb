class Legal::HostingAbuse::CannedReply
  
  attr_reader :abuse
  
  def initialize hosting_abuse
    @abuse    = hosting_abuse
    @template = get_template
  end
  
  def render
    @template.try :result, binding
  end
  
  private
  
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
    return 'resource_abuse_lve.txt.erb' if @abuse.type.name == 'Resource Abuse' && @abuse.resource.type.name == 'LVE / MySQL'
  end
  
  def templates_folder_path
    File.join Rails.root, 'app', 'models', 'legal', 'hosting_abuse', 'canned_reply'
  end
  
end