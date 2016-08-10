class Legal::Pdf::Admin < Legal::Pdf

  def initialize pdf, data, exported_at = nil
    @pdf, @data, @exported_at = pdf, data, exported_at
    render!
  end

  private

  def render!
    page_break!
    add_page_title title
    add_table [header] + body
    add_export_date @exported_at
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
