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
        content = column.split(', ').map do |c|
          # TODO Chrome extension exports this line with key 'Street 2' :(
          # If we decide to fix this, we'll have to update all exisiting
          # records in the DB
          c = 'Street 2' if c == 'Address 2'
          whois[c]
        end.join(', ')
        [
          { content: "#{column}:",  width: bounds.width / 6, align: :right },
          { content: content,       width: bounds.width / 6 }
        ]
      end.flatten
    end
  end

end
