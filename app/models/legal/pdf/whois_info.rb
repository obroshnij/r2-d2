class Legal::Pdf::WhoisInfo < Legal::Pdf::Admin

  private

  def render!
    @data.each do |whois|
      page_break!
      add_page_title "Whois details for #{whois['Domain Name']}"
      render_whois whois['Whois']
      add_export_date @exported_at
    end
  end

  def render_whois whois
    %w{ Registrant Administrative Technical Billing }.each do |type|
      render_whois_section whois, type
    end
  end

  def render_whois_section whois, type
    text "\n#{type} Contact", size: 7, leading: 5, style: :bold
    table get_data(whois[type]), {
      width:      bounds.width,
      cell_style: {
        borders: [],
        padding: 2
      }
    }
  end

  def get_data whois
    [
      %w{ First\ Name Last\ Name Organization },
      %w{ Street\ Address Address\ 2 Job\ Title },
      %w{ City State/Province,\ Zip/Postal\ Code Country },
      %w{ Email\ Address Phone\ Number Fax\ Number }
    ].map do |row|
      row.map do |column|
        content = column.split(', ').map { |c| whois[c] }.join(', ')
        [
          { content: "#{column}:",  width: bounds.width / 6, align: :right },
          { content: content,       width: bounds.width / 6 }
        ]
      end.flatten
    end
  end

end
