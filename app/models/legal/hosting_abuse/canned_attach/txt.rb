class Legal::HostingAbuse::CannedAttach::Txt
  
  def render template
    template.lines.map(&:strip).join("\r\n")
  end
  
end