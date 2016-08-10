class Legal::Pdf

  LOGO = "#{Rails.root}/app/assets/images/namecheap.png"

  def initialize
    @pdf = Prawn::Document.new margin: [45, 35, 35]
    @pdf.font_families.update('SourceSansPro' => {
      normal: "#{Rails.root}/vendor/assets/fonts/SourceSansPro-Regular.ttf",
      bold:   "#{Rails.root}/vendor/assets/fonts/SourceSansPro-Bold.ttf"
    })
    @pdf.font 'SourceSansPro'
    @pdf.font_size 5
    @pdf.fill_color '0a0a0a'
    add_logo
  end

  def add_report_page page
    send "add_#{page['page']}", page['data'], page['exported_at']
  end

  private

  def add_export_date time = nil
    text "\nExported on #{Time.parse(time).strftime('%b/%d/%Y')}", align: :right, size: 7 if time
  end

  def add_logo
    repeat(:all) do
      image LOGO, at: [bounds.top_left.first, bounds.top_left.last + 25], height: 15
    end
  end

  def add_table data
    table data, {
      width:      bounds.width,
      header:     true,
      cell_style: {
        border_width: 0.25,
        padding:      2,
        borders:      [:top, :bottom],
        border_color: 'e1e1e1'
      },
      row_colors: ['ffffff', 'f1f1f1']
    } do |table|
      table.row(0).font_style = :bold
      table.row(0).background_color = 'f8f8f8'

      table.before_rendering_page do |page|
        page.column(0).borders  = [:left, :top, :bottom]
        page.column(-1).borders = [:right, :top, :bottom]
      end
    end
  end

  def add_page_title title
    text title, align: :center, size: 10, leading: 5, style: :bold
  end

  def method_missing name, *args, &block
    if @pdf.respond_to?(name)
      @pdf.send(name, *args, &block)

    elsif subclass = get_pdf_subclass(name)
      subclass.new @pdf, *args

    else
      super

    end
  end

  def get_pdf_subclass name
    return false unless name[0..3] == 'add_'
    ('Legal::Pdf::' + name[4..-1].classify).constantize
  rescue NameError
    nil
  end

end
