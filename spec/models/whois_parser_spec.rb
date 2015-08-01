require 'rails_helper'

RSpec.describe WhoisParser, :type => :model do
  
  before(:all) do
    @whois_data = File.open('spec/test_whois_data.json') { |f| JSON.parse(f.read) }
  end
  
  it 'parses correct properties for .COM domains' do
    registered = WhoisParser.parse 'google.com', @whois_data['google.com']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status].sort).to       eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers].sort).to  eq(['ns1.google.com', 'ns2.google.com', 'ns3.google.com', 'ns4.google.com'].sort)
    expect(registered[:creation_date]).to     eq(DateTime.parse('1997-09-15T00:00:00-0700').to_s)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('2020-09-13T21:00:00-0700').to_s)
    expect(registered[:updated_date]).to      eq(DateTime.parse('2015-06-12T10:38:52-0700').to_s)
    expect(registered[:registrar]).to         eq('MARKMONITOR INC.')
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.com', @whois_data['zyxqvutsrqponmlkjihgfedcba.com']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
  it 'parses correct properties for .NET domains' do
    registered = WhoisParser.parse 'google.net', @whois_data['google.net']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status].sort).to       eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers].sort).to  eq(['ns1.google.com', 'ns2.google.com', 'ns3.google.com', 'ns4.google.com'].sort)
    expect(registered[:creation_date]).to     eq(DateTime.parse('1999-03-15T00:00:00-0800').to_s)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('2016-03-14T00:00:00-0700').to_s)
    expect(registered[:updated_date]).to      eq(DateTime.parse('2015-02-11T02:20:36-0800').to_s)
    expect(registered[:registrar]).to         eq('MARKMONITOR INC.')
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.net', @whois_data['zyxqvutsrqponmlkjihgfedcba.net']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
  it 'parses correct properties for .ORG domains' do
    registered = WhoisParser.parse 'verisign.org', @whois_data['verisign.org']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status].sort).to       eq(['clientTransferProhibited'].sort)
    expect(registered[:nameservers].sort).to  eq(['l4.nstld.com','a4.nstld.com','f4.nstld.com','g4.nstld.com','h4.nstld.com','j4.nstld.com','k4.nstld.com'].sort)
    expect(registered[:creation_date]).to     eq(DateTime.parse('1999-12-17T20:43:27Z').to_s)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('2015-12-17T20:43:27Z').to_s)
    expect(registered[:updated_date]).to      eq(DateTime.parse('2014-07-18T00:20:23Z').to_s)
    expect(registered[:registrar]).to         eq('CSC Corporate Domains, Inc. (R24-LROR)')
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.org', @whois_data['zyxqvutsrqponmlkjihgfedcba.org']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
  it 'parses correct properties for .INFO domains' do
    registered = WhoisParser.parse 'nic.info', @whois_data['nic.info']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status].sort).to       eq(['serverDeleteProhibited', 'serverRenewProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers].sort).to  eq(['ns1.ams1.afilias-nst.info', 'ns1.mia1.afilias-nst.info', 'ns1.sea1.afilias-nst.info', 'ns1.yyz1.afilias-nst.info', 'ns1.hkg1.afilias-nst.info'].sort)
    expect(registered[:creation_date]).to     eq(DateTime.parse('2001-07-27T19:05:24Z').to_s)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('2011-07-27T19:05:24Z').to_s)
    expect(registered[:updated_date]).to      eq(DateTime.parse('2010-10-26T19:41:08Z').to_s)
    expect(registered[:registrar]).to         eq('Afilias (R145-LRMS)')
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.info', @whois_data['zyxqvutsrqponmlkjihgfedcba.info']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
  it 'parses correct properties for .BIZ domains' do
    registered = WhoisParser.parse 'nic.biz', @whois_data['nic.biz']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status].sort).to       eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers].sort).to  eq(['pdns1.ultradns.net', 'pdns2.ultradns.net', 'pdns3.ultradns.org', 'pdns4.ultradns.org', 'pdns5.ultradns.info', 'pdns6.ultradns.co.uk'].sort)
    expect(registered[:creation_date]).to     eq(DateTime.parse('Wed Nov 07 00:01:00 GMT 2001').to_s)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('Fri Nov 06 23:59:00 GMT 2015').to_s)
    expect(registered[:updated_date]).to      eq(DateTime.parse('Mon Dec 22 01:41:55 GMT 2014').to_s)
    expect(registered[:registrar]).to         eq('REGISTRY REGISTRAR')
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.biz', @whois_data['zyxqvutsrqponmlkjihgfedcba.biz']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
  it 'parses correct properties for .UK domains' do
    registered = WhoisParser.parse 'nominet.uk', @whois_data['nominet.uk']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status]).to            eq(['Registered until expiry date.'])
    expect(registered[:nameservers].sort).to  eq(['nom-ns1.nominet.org.uk', 'nom-ns2.nominet.org.uk', 'nom-ns3.nominet.org.uk'].sort)
    expect(registered[:creation_date]).to     eq(DateTime.parse('10-Jun-2014').to_s)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('10-Jun-2016').to_s)
    expect(registered[:registrar]).to         eq('No registrar listed.  This domain is registered directly with Nominet.')
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.uk', @whois_data['zyxqvutsrqponmlkjihgfedcba.uk']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
  it 'parses correct properties for .IO domains' do
    registered = WhoisParser.parse 'namecheap.io', @whois_data['namecheap.io']
    expect(registered[:available]).to         eq(false)
    expect(registered[:status]).to            eq(['Live'])
    expect(registered[:nameservers].sort).to  eq(['dns1.namecheaphosting.com', 'dns2.namecheaphosting.com'].sort)
    expect(registered[:expiration_date]).to   eq(DateTime.parse('2015-10-22').to_s)
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.io', @whois_data['zyxqvutsrqponmlkjihgfedcba.io']
    expect(unregistered[:available]).to       eq(true)
    expect(unregistered.keys.count).to        eq(1)
  end
  
end