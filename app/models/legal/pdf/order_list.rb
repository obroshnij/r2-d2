class Legal::Pdf::OrderList < Legal::Pdf::Admin

  def title() 'Order List'; end

  private

  def header
    [
      %w{ Order\ ID User Date },
      %w{ CC\ Order\ ID Transaction\ ID },
      %w{ Amount Type Promotion\ Code },
      %w{ Items }
    ].map { |th| th.join("\n") }
  end

  def body
    @data.map do |row|
      [
        "#{row['Order ID']}\n#{row['User']}\n#{row['Date']}",
        "#{row['CC Order ID']}\n#{row['Transaction ID']}",
        "#{row['Amount']}\n#{row['Type']}\n#{row['Promotion Code']}",
        items_table(row['Items'])
      ]
    end
  end

  def items_table items
    total_width = bounds.width * 0.6

    options = {
      width:      total_width,
      cell_style: {
        borders: [],
        padding: 2
      }
    }

    data = items.map do |item|
      [
        { content: "Type: #{item['Type']}\n#{item['Name']}", width: total_width * 0.35 },
        { content: item['Info'].join("\n"), width: total_width * 0.1 },
        "Successful: #{item['Success']}\n#{item['Error']}"
      ]
    end

    make_table data, options
  end

end
