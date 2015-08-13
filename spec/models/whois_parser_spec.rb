require 'rails_helper'

RSpec.describe WhoisParser, :type => :model do
  
  before(:all) do
    @whois_data = File.open('spec/test_whois_data.json') { |f| JSON.parse(f.read) }
  end
  
  it 'parses correct properties for .COM domains' do
    registered = WhoisParser.parse 'google.com', @whois_data['google.com']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers]).to        eq(['ns1.google.com', 'ns2.google.com', 'ns3.google.com', 'ns4.google.com'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('1997-09-15T00:00:00-0700').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('2020-09-13T21:00:00-0700').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('2015-06-12T10:38:52-0700').to_s)
    expect(registered[:registrar]).to          eq('MARKMONITOR INC.')
    expect(registered[:registrant_contact]).to eq("Dns Admin\nGoogle Inc.\nPlease contact contact-admin@google.com, 1600 Amphitheatre Parkway\nMountain View\nCA\n94043\nUS\n+1.6502530000\n+1.6506188571\ndns-admin@google.com")
    expect(registered[:admin_contact]).to      eq("DNS Admin\nGoogle Inc.\n1600 Amphitheatre Parkway\nMountain View\nCA\n94043\nUS\n+1.6506234000\n+1.6506188571\ndns-admin@google.com")
    expect(registered[:tech_contact]).to       eq("DNS Admin\nGoogle Inc.\n2400 E. Bayshore Pkwy\nMountain View\nCA\n94043\nUS\n+1.6503300100\n+1.6506181499\ndns-admin@google.com")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.com', @whois_data['zyxqvutsrqponmlkjihgfedcba.com']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .NET domains' do
    registered = WhoisParser.parse 'google.net', @whois_data['google.net']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers]).to        eq(['ns1.google.com', 'ns2.google.com', 'ns3.google.com', 'ns4.google.com'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('1999-03-15T00:00:00-0800').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('2016-03-14T00:00:00-0700').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('2015-02-11T02:20:36-0800').to_s)
    expect(registered[:registrar]).to          eq('MARKMONITOR INC.')
    expect(registered[:registrant_contact]).to eq("DNS Admin\nGoogle Inc.\n1600 Amphitheatre Parkway\nMountain View\nCA\n94043\nUS\n+1.6506234000\n+1.6506188571\ndns-admin@google.com")
    expect(registered[:admin_contact]).to      eq("DNS Admin\nGoogle Inc.\n1600 Amphitheatre Parkway\nMountain View\nCA\n94043\nUS\n+1.6506234000\n+1.6506188571\ndns-admin@google.com")
    expect(registered[:tech_contact]).to       eq("DNS Admin\nGoogle Inc.\n1600 Amphitheatre Parkway\nMountain View\nCA\n94043\nUS\n+1.6506234000\n+1.6506188571\ndns-admin@google.com")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.net', @whois_data['zyxqvutsrqponmlkjihgfedcba.net']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .ORG domains' do
    registered = WhoisParser.parse 'verisign.org', @whois_data['verisign.org']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['clientTransferProhibited'].sort)
    expect(registered[:nameservers]).to        eq(['l4.nstld.com','a4.nstld.com','f4.nstld.com','g4.nstld.com','h4.nstld.com','j4.nstld.com','k4.nstld.com'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('1999-12-17T20:43:27Z').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('2015-12-17T20:43:27Z').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('2014-07-18T00:20:23Z').to_s)
    expect(registered[:registrar]).to          eq('CSC Corporate Domains, Inc. (R24-LROR)')
    expect(registered[:registrant_contact]).to eq("51017312fa891195\nVeriSign Inc.\nVeriSign, Inc.\n12061 Bluemont Way\nReston\nVA\n20190\nUS\n+1.7039484300\n+1.7039484331\nvshostmaster@verisign.com")
    expect(registered[:admin_contact]).to      eq("30324102fa7c4816\nVeriSign Hostmaster\nVeriSign, Inc.\n12061 Bluemont Way\nReston\nVirginia\n20190\nUS\n+1.7039484300\n+1.7039484331\nvshostmaster@verisign.com")
    expect(registered[:tech_contact]).to       eq("19672192fa84f149\nVeriSign Hostmaster\nVeriSign, Inc.\n12061 Bluemont Way\nReston\nVirginia\n20190\nUS\n+1.7039484300\n+1.7039484331\nvshostmaster@verisign.com")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.org', @whois_data['zyxqvutsrqponmlkjihgfedcba.org']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .INFO domains' do
    registered = WhoisParser.parse 'nic.info', @whois_data['nic.info']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['serverDeleteProhibited', 'serverRenewProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers]).to        eq(['ns1.ams1.afilias-nst.info', 'ns1.mia1.afilias-nst.info', 'ns1.sea1.afilias-nst.info', 'ns1.yyz1.afilias-nst.info', 'ns1.hkg1.afilias-nst.info'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('2001-07-27T19:05:24Z').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('2011-07-27T19:05:24Z').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('2010-10-26T19:41:08Z').to_s)
    expect(registered[:registrar]).to          eq('Afilias (R145-LRMS)')
    expect(registered[:registrant_contact]).to eq("C2283145-LRMS\nInternet Corporation for Assigned Names and Numbers\nICANN\n4676 Admiralty Way\nSuite 330\nMarina Del Rey\nCA\n90292-6601\nUS\n+1.2157065700\n+1.2157065701\nsupport@afilias.info")
    expect(registered[:admin_contact]).to      eq("C2283145-LRMS\nInternet Corporation for Assigned Names and Numbers\nICANN\n4676 Admiralty Way\nSuite 330\nMarina Del Rey\nCA\n90292-6601\nUS\n+1.2157065700\n+1.2157065701\nsupport@afilias.info")
    expect(registered[:billing_contact]).to    eq("C2283145-LRMS\nInternet Corporation for Assigned Names and Numbers\nICANN\n4676 Admiralty Way\nSuite 330\nMarina Del Rey\nCA\n90292-6601\nUS\n+1.2157065700\n+1.2157065701\nsupport@afilias.info")
    expect(registered[:tech_contact]).to       eq("C2283145-LRMS\nInternet Corporation for Assigned Names and Numbers\nICANN\n4676 Admiralty Way\nSuite 330\nMarina Del Rey\nCA\n90292-6601\nUS\n+1.2157065700\n+1.2157065701\nsupport@afilias.info")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.info', @whois_data['zyxqvutsrqponmlkjihgfedcba.info']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .BIZ domains' do
    registered = WhoisParser.parse 'nic.biz', @whois_data['nic.biz']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['clientDeleteProhibited', 'clientTransferProhibited', 'clientUpdateProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers]).to        eq(['pdns1.ultradns.net', 'pdns2.ultradns.net', 'pdns3.ultradns.org', 'pdns4.ultradns.org', 'pdns5.ultradns.info', 'pdns6.ultradns.co.uk'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('Wed Nov 07 00:01:00 GMT 2001').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('Fri Nov 06 23:59:00 GMT 2015').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('Mon Dec 22 01:41:55 GMT 2014').to_s)
    expect(registered[:registrar]).to          eq('REGISTRY REGISTRAR')
    expect(registered[:registrant_contact]).to eq("NEULEVEL1\nNeuStar, Inc.\nNeuStar, Inc.\nLoudoun Tech Center\n45980 Center Oak Plaza\nSterling\nVirginia\n20166\nUnited States\nUS\n+1.5714345757\n+1.5714345758\nsupport@NeuStar.biz")
    expect(registered[:admin_contact]).to      eq("NEULEVEL1\nNeuStar, Inc.\nNeuStar, Inc.\nLoudoun Tech Center\n45980 Center Oak Plaza\nSterling\nVirginia\n20166\nUnited States\nUS\n+1.5714345757\n+1.5714345758\nsupport@NeuStar.biz")
    expect(registered[:billing_contact]).to    eq("NEULEVEL1\nNeuStar, Inc.\nNeuStar, Inc.\nLoudoun Tech Center\n45980 Center Oak Plaza\nSterling\nVirginia\n20166\nUnited States\nUS\n+1.5714345757\n+1.5714345758\nsupport@NeuStar.biz")
    expect(registered[:tech_contact]).to       eq("NEULEVEL1\nNeuStar, Inc.\nNeuStar, Inc.\nLoudoun Tech Center\n45980 Center Oak Plaza\nSterling\nVirginia\n20166\nUnited States\nUS\n+1.5714345757\n+1.5714345758\nsupport@NeuStar.biz")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.biz', @whois_data['zyxqvutsrqponmlkjihgfedcba.biz']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .UK domains' do
    registered = WhoisParser.parse 'nominet.uk', @whois_data['nominet.uk']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['Registered until expiry date.'])
    expect(registered[:nameservers]).to        eq(['nom-ns1.nominet.org.uk', 'nom-ns2.nominet.org.uk', 'nom-ns3.nominet.org.uk'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('10-Jun-2014').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('10-Jun-2016').to_s)
    expect(registered[:registrar]).to          eq('No registrar listed.  This domain is registered directly with Nominet.')
    expect(registered[:registrant_contact]).to eq("Nominet UK\nUK Limited Company, (Company number: 3203859)\nMinerva House\nEdmund Halley Road\nOxford Science Park\nOxford\nOxon\nOX4 4DQ\nUnited Kingdom")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.uk', @whois_data['zyxqvutsrqponmlkjihgfedcba.uk']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .IO domains' do
    registered = WhoisParser.parse 'namecheap.io', @whois_data['namecheap.io']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['Live'])
    expect(registered[:nameservers]).to        eq(['dns1.namecheaphosting.com', 'dns2.namecheaphosting.com'].sort)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('2015-10-22').to_s)
    expect(registered[:registrant_contact]).to eq("NameCheap.com NameCheap.com\nNameCheap, Inc\n11400 W. Olympic Blvd. Suite 200\nLos Angeles\nCA\nUS")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.io', @whois_data['zyxqvutsrqponmlkjihgfedcba.io']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .EU domains' do
    registered = WhoisParser.parse 'nic.eu', @whois_data['nic.eu']
    expect(registered[:available]).to          eq(false)
    expect(registered[:nameservers]).to        eq(['ns4.eurid.eu', 'ns2.eurid.eu', 'ns1.eurid.eu', 'ns3.eurid.eu'].sort)
    expect(registered[:registrar]).to          eq('EURid vzw/asbl')
    expect(registered[:registrant_contact]).to eq("NOT DISCLOSED!\nVisit www.eurid.eu for webbased whois.")
    expect(registered[:tech_contact]).to       eq("EURid vzw/asbl Technical staff\nEURid vzw/asbl\nen\n+32.24012750\n+32.24012751\ntech@eurid.eu")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.eu', @whois_data['zyxqvutsrqponmlkjihgfedcba.eu']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .US domains' do
    registered = WhoisParser.parse 'nic.us', @whois_data['nic.us']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['clientDeleteProhibited', 'clientTransferProhibited', 'serverDeleteProhibited', 'serverTransferProhibited', 'serverUpdateProhibited'].sort)
    expect(registered[:nameservers]).to        eq(['pdns1.ultradns.net', 'pdns2.ultradns.net', 'pdns3.ultradns.org', 'pdns4.ultradns.org', 'pdns5.ultradns.info', 'pdns6.ultradns.co.uk'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('Thu Apr 18 19:23:48 GMT 2002').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('Sun Apr 17 23:59:59 GMT 2016').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('Tue Jun 02 01:32:02 GMT 2015').to_s)
    expect(registered[:registrar]).to          eq('REGISTRY REGISTRAR')
    expect(registered[:registrant_contact]).to eq("NEUSTAR7\n.US Registration Policy\n46000 Center Oak Plaza\nSterling\nVA\n20166\nUnited States\nUS\n+1.5714345728\nsupport.us@neustar.us\nP5\nC21")
    expect(registered[:admin_contact]).to      eq("NEUSTAR7\n.US Registration Policy\n46000 Center Oak Plaza\nSterling\nVA\n20166\nUnited States\nUS\n+1.5714345728\nsupport.us@neustar.us\nP5\nC21")
    expect(registered[:billing_contact]).to    eq("NEUSTAR7\n.US Registration Policy\n46000 Center Oak Plaza\nSterling\nVA\n20166\nUnited States\nUS\n+1.5714345728\nsupport.us@neustar.us\nP5\nC21")
    expect(registered[:tech_contact]).to       eq("NEUSTAR7\n.US Registration Policy\n46000 Center Oak Plaza\nSterling\nVA\n20166\nUnited States\nUS\n+1.5714345728\nsupport.us@neustar.us\nP5\nC21")
    
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.us', @whois_data['zyxqvutsrqponmlkjihgfedcba.us']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .CA domains' do
    registered = WhoisParser.parse 'cira.ca', @whois_data['cira.ca']
    expect(registered[:available]).to          eq(false)
    expect(registered[:nameservers]).to        eq(['ns01.cira.ca', 'ns02.cira.ca', 'ns1.d-zone.ca', 'ns2.d-zone.ca'].sort)
    expect(registered[:creation_date]).to      eq(DateTime.parse('1998/02/05').to_s)
    expect(registered[:expiration_date]).to    eq(DateTime.parse('2050/02/05').to_s)
    expect(registered[:updated_date]).to       eq(DateTime.parse('2014/11/25').to_s)
    expect(registered[:registrar]).to          eq('Please contact CIRA at 1-877-860-1411 for more information')
    expect(registered[:registrant_contact]).to eq("Canadian Internet Registration Authority (NFP) / Autorit� Canadienne pour les enregistrements Internet (OSBL)")
    expect(registered[:admin_contact]).to      eq("Tanya O'Callaghan\nCanadian Internet Registration Authority\n979 Bank Street\nSuite 400\nOttawa ON K1S5K5 Canada\n+1.6132375335\n+1.6132370534\ndomains@cira.ca")
    expect(registered[:tech_contact]).to       eq("Address Reply To\n979 Bank Street\nSuite 400\nOttawa ON K1S5K5 Canada\n+1.6132375335\nregtrant-conf@cira.ca")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.ca', @whois_data['zyxqvutsrqponmlkjihgfedcba.ca']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  it 'parses correct properties for .AU domains' do
    registered = WhoisParser.parse 'nic.org.au', @whois_data['nic.org.au']
    expect(registered[:available]).to          eq(false)
    expect(registered[:status]).to             eq(['ok'])
    expect(registered[:nameservers]).to        eq(['ns1.accountsupport.com', 'ns2.accountsupport.com'].sort)
    expect(registered[:updated_date]).to       eq(DateTime.parse('09-Jan-2014 23:30:35 UTC').to_s)
    expect(registered[:registrar]).to          eq('IntaServe')
    expect(registered[:registrant_contact]).to eq("Regional Development Australia Yorke and Mid North Incorporated\nABN 68705101048\nHB9U2C7\nNatalie McElroy\nVisit whois.ausregistry.com.au for Web based WhoIs\nEligibility:\nOther\nRegional Development Australia Yorke and Mid North Incorporated\nABN 68705101048")
    expect(registered[:tech_contact]).to       eq("HB9U2C7\nNatalie McElroy\nVisit whois.ausregistry.com.au for Web based WhoIs")
    
    unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.org.au', @whois_data['zyxqvutsrqponmlkjihgfedcba.org.au']
    expect(unregistered[:available]).to        eq(true)
    expect(unregistered.keys.count).to         eq(1)
  end
  
  # it 'parses correct properties for .BZ domains' do
  #   registered = WhoisParser.parse 'nic.bz', @whois_data['nic.bz']
  #   expect(registered[:available]).to          eq(false)
  #   expect(registered[:status]).to             eq(['CLIENT DELETE PROHIBITED', 'CLIENT TRANSFER PROHIBITED', 'RENEWPERIOD'].sort)
  #   expect(registered[:nameservers]).to        eq(['ns1.belizenic.bz', 'pixie.ucb.edu.bz'].sort)
  #   expect(registered[:creation_date]).to      eq(DateTime.parse('15-Dec-2004 06:10:00 UTC').to_s)
  #   expect(registered[:expiration_date]).to    eq(DateTime.parse('15-Dec-2016 06:10:00 UTC').to_s)
  #   expect(registered[:updated_date]).to       eq(DateTime.parse('21-Aug-2014 17:17:22 UTC').to_s)
  #   expect(registered[:registrar]).to          eq('University Management Limited (R113-LRCC)')
  #
  #   unregistered = WhoisParser.parse 'zyxqvutsrqponmlkjihgfedcba.bz', @whois_data['zyxqvutsrqponmlkjihgfedcba.bz']
  #   expect(unregistered[:available]).to        eq(true)
  #   expect(unregistered.keys.count).to         eq(1)
  # end
  
end
