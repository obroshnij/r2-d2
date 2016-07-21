class PdfReport

  LOGO = "#{Rails.root}/app/assets/images/namecheap.png"

  def initialize
    @pdf = Prawn::Document.new margin: [45, 35, 35]
    add_logo
  end

  def render
    render_file "/Users/Stas/Desktop/123.pdf"
  end

  def add_logo
    repeat(:all) do
      image LOGO, at: [bounds.top_left.first, bounds.top_left.last + 25], height: 15
    end
  end

  def add_table data
    table data, width: bounds.width
  end

  def method_missing name, *args, &block
    @pdf.respond_to?(name) ? @pdf.send(name, *args, &block) : super
  end

end
