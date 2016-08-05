class Legal::Pdf::Admin < Legal::Pdf

  def initialize pdf, data
    @pdf, @data = pdf, data
    render!
  end

  private

  def render!
    page_break!
    add_page_title title
    add_table [header] + body
  end

  def header
    @data.first.keys
  end

  def body
    @data.map do |row|
      header.map { |h| row[h].is_a?(Array) ? row[h].join("\n") : row[h] }
    end
  end

  def page_break!
    start_new_page unless cursor == bounds.top_left.last
  end

end
