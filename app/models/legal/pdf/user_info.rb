class Legal::Pdf::UserInfo < Legal::Pdf::Admin

  def title() 'User Info'; end

  private

  def header
    [
      ['Username', 'User ID', 'Account Locked'],
      ['First Name', 'Last Name', 'Email'],
      ['Support Pin', 'Pin Expiry'],
      ['Signup Date', 'Signup IP', ],
      ['Account Balance', 'Available Balance', 'Earned Amount'],
      ['Organization', 'Street Address', 'City, State'],
      ['Phone', 'Fax', 'Country, Zip'],
      ['Latest Transaction', 'Latest Login', 'Login IP']
    ].map { |th| th.join("\n") }
  end

  def body
    @data.map do |row|
      [
        [row['Username'], row['User ID'], row['Account Locked']],
        [row['First Name'], row['Last Name'], row['Email']],
        [row['Support Pin'], row['Pin Expiry']],
        [row['Signup Date'], row['Signup IP'], ],
        [row['Account Balance'], row['Available Balance'], row['Earned Amount']],
        [row['Organization'], row['Street Address'], row['City, State']],
        [row['Phone'], row['Fax'], row['Country, Zip']],
        [row['Latest Transaction'], row['Latest Login'], row['Login IP']]
      ].map { |td| td.join("\n") }
    end
  end

end
