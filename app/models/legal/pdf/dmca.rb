class Legal::Pdf::Dmca < Legal::Pdf

  def initialize content
    super logo: false, font_size: 12
    @content = content
    render!
  end

  def name
    'DMCA.pdf'
  end

  private

  attr_reader :content

  def render!
    table content, {
      width:      bounds.width,
      header:     false,
      cell_style: {
        border_width: 0,
        padding:      2,
        borders:      [],
        padding:      [0, 0, 10, 2]
      }
    } do |table|
      table.column(0).font_style = :bold
      table.column(0).width = bounds.width / 3
    end
  end

end
