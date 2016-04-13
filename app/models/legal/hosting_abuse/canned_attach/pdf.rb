class Legal::HostingAbuse::CannedAttach::Pdf
  
  def initialize
    @pdf = Prawn::Document.new page_layout: :landscape
    @pdf.font 'Courier'
    @pdf.font_size 5
  end
  
  def render template
    @pdf.text template
    @pdf.render
  end
  
end