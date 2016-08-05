class Legal::Pdf::DomainList < Legal::Pdf::Admin

  def title() 'Domain List'; end

  private

  def header
    (
      [
        ['Domain', 'ID'],
        ['User', 'ID'],
        ['Expiration', 'Creation', 'Registration'],
        ['CC Order ID', 'CC Transaction ID']
      ] +
      @data.first['Properties'].keys.map { |key| { content: key, width: 35, align: :center, valign: :center } }
    ).map { |th| th.is_a?(Array) ? th.join("\n") : th }
  end

  def body
    @data.map do |row|
      (
        [
          [row['Domain Name'], row['Domain ID']],
          [row['User'], row['User ID']],
          [row['Expiration Date'], row['Creation Date'], row['Registration Date']],
          [row['CC Order ID'], row['CC Transaction ID']]
        ] + @data.first['Properties'].keys.map { |p| row['Properties'][p] ? { content: '✓', align: :center, valign: :center, size: 8 } : [''] }
      ).map { |td| td.is_a?(Array) ? td.join("\n") : td }
    end
  end

end
