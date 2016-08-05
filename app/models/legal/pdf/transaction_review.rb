class Legal::Pdf::TransactionReview < Legal::Pdf::Admin

  def title() 'Transaction Review'; end

  private

  def header
    [
      { content: 'ID', width: 30 },
      ['Username', 'IP (Country)'],
      ['CC Order ID', 'CC Transaction ID'],
      ['Transaction Type', 'Payment Source'],
      { content: 'Amount', width: 25 },
      ['Status', 'Score'],
      ['CC-L4(exp)', 'Country IP / Bill'],
      ['Date (PST)'],
      { content: 'Order ID', width: 30 },
      ['Name on Card', 'Email'],
      ['Balance Before', 'Balance After']
    ].map { |th| th.is_a?(Array) ? th.join("\n") : th }
  end

  def body
    @data.map do |row|
      [
        [row['ID']],
        [row['Username'], row['IP (Country)']],
        [row['CC Order ID'], row['CC Transaction ID']],
        [row['Transaction Type'], row['Payment Source']],
        [row['Amount']],
        [row['Status'], row['Score']],
        [row['CC-L4(exp)'], row['Country IP / Bill']],
        [row['Date (PST)']],
        [row['Order ID']],
        [row['Name on Card'], row['Email']],
        [row['Balance Before'], row['Balance After']]
      ].map { |th| th.join("\n") }
    end
  end

end
