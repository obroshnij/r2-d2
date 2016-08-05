class Legal::Pdf::SslList < Legal::Pdf::Admin

  def title() 'SSL List'; end

  private

  def header
    [
      { content: 'ID', width: 30 },
      ['Domain/CN', 'Type (Partner Name)'],
      ['Status', 'Next Check Date'],
      ['Username', 'Approver Email', 'Admin Contact Email'],
      ['Purchase Date', 'Completed Date', 'Expiration Date'],
      { content: 'Active Till', width: 60 },
      ['Issuer Order ID', 'Issuer Cert ID', 'Order ID', 'Years'],
      ['Related Cert ID', 'Enom Cert ID', 'Web Server']
    ].map { |th| th.is_a?(Array) ? th.join("\n") : th }
  end

  def body
    @data.map do |row|
      [
        [row['ID']],
        [row['Domain/CN'], row['Type (Partner Name)']],
        [row['Status'], row['Next Check Date']],
        [row['Username'], row['Approver Email'], row['Admin Contact Email']],
        [row['Purchase Date'], row['Completed Date'], row['Expiration Date']],
        [row['Active Till']],
        [row['Issuer Order ID'], row['Issuer Cert ID'], row['Order ID'], row['Years']],
        [row['Related Cert ID'], row['Enom Cert ID'], row['Web Server']]
      ].map { |td| td.join("\n") }
    end
  end

end
