require 'rails_helper'

RSpec.describe WhoisParser, :type => :model do
  
  it 'parses correct properties for .COM domains' do
    registered = WhoisParser.parse 'google.com', Whois.lookup('google.com')
    expect(registered[:available]).to eq(false)
    expect(registered[:status]).to eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'])
    expect(registered[:nameservers].sort).to eq(['ns1.google.com', 'ns2.google.com', 'ns3.google.com', 'ns4.google.com'].sort)
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.com', Whois.lookup('zyxqvutsrqponmlkjihgfedcba.com')
    expect(unregistered[:available]).to eq(true)
    expect(unregistered[:status]).to eq([])
    expect(unregistered[:nameservers]).to eq([])
  end
  
  it 'parses correct properties for .NET domains' do
    registered = WhoisParser.parse 'google.net', Whois.lookup('google.net')
    expect(registered[:available]).to eq(false)
    expect(registered[:status]).to eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'])
    expect(registered[:nameservers].sort).to eq(['ns1.google.com', 'ns2.google.com', 'ns3.google.com', 'ns4.google.com'].sort)
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.net', Whois.lookup('zyxqvutsrqponmlkjihgfedcba.net')
    expect(unregistered[:available]).to eq(true)
    expect(unregistered[:status]).to eq([])
    expect(unregistered[:nameservers]).to eq([])
  end
  
  it 'parses correct properties for .ORG domains' do
    registered = WhoisParser.parse 'verisign.org', Whois.lookup('verisign.org')
    expect(registered[:available]).to eq(false)
    expect(registered[:status]).to eq(['clientTransferProhibited'])
    expect(registered[:nameservers].sort).to eq(['l4.nstld.com','a4.nstld.com','f4.nstld.com','g4.nstld.com','h4.nstld.com','j4.nstld.com','k4.nstld.com'].sort)
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.org', Whois.lookup('zyxqvutsrqponmlkjihgfedcba.org')
    expect(unregistered[:available]).to eq(true)
    expect(unregistered[:status]).to eq([])
    expect(unregistered[:nameservers]).to eq([])
  end
  
end

