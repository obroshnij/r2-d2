class HostingAbuseSpam
  
  class ReportingParty
    
    PARTIES = [
      "AOL",
      "Blue Tie",
      "Comcast",
      "Cox",
      "FastMail",
      "HostedEmail",
      "Hotmail",
      "Microsoft",
      "PhoenixNAP",
      "Rackspace",
      "ReturnPath",
      "RoadRunner",
      "SpamExperts",
      "Synacor",
      "Terra (Brazil)",
      "USA.net",
      "United Online",
      "Yahoo",
      "Zoho"
    ]
    
    def self.all
      PARTIES.each_with_index.map do |name, index|
        { value: index + 1, name: name }
      end
    end
    
  end
  
end