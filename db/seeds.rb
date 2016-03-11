# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['Internal Spammer Blacklist', 'DNS DDoS', 'PE Abuse', 'Abuse Notes'].each do |name|
  AbuseReportType.create name: name
end

['Internal Spammer', 'Spammer Related', 'DNS DDoSer', 'DDoSer Related', 'PE Abuser', 'Has Abuse Notes', 'Has VIP Domains', 'Internal Account', 'VIP'].each do |name|
  Status.create name: name
end

['IP Address', 'Payment', 'Password', 'Unknown', 'Email Address', 'Contacts'].each do |name|
  RelationType.create name: name
end

['Domain', 'Private Email'].each do |name|
  NcServiceType.create name: name
end

['VIP', 'Abused out', 'DDoS Related', 'FreeDNS'].each do |name|
  ServiceStatus.create name: name
end

['Direct', 'Indirect'].each do |name|
  ReportAssignmentType.create name: name
end

['Urgent', 'Important', 'Unimportant'].each do |name|
  RblStatus.create name: name
end

########################################################

[
  { name: 'Shared Hosting',   properties: { url: 'https://www.namecheap.com/hosting/shared.aspx' } },
  { name: 'Reseller Hosting', properties: { url: 'https://www.namecheap.com/hosting/reseller.aspx' } },
  { name: 'VPS Hosting',      properties: { url: 'https://www.namecheap.com/hosting/vps.aspx' } },
  { name: 'Dedicated Server', properties: { url: 'https://www.namecheap.com/hosting/dedicated-servers.aspx' } },
  { name: 'Private Email',    properties: { url: 'https://www.namecheap.com/hosting/email.aspx' } },
  { name: 'Email Forwarding', properties: {} }
].each do |service|
  Legal::HostingAbuse::Service.create name: service[:name], properties: service[:properties]
end

['Email Abuse / Spam', 'Resource Abuse', 'DDoS', 'Other'].each do |name|
  Legal::HostingAbuse::AbuseType.create name: name
end

['None', 'Partial', 'Full'].each do |name|
  Legal::HostingAbuse::ManagementType.create name: name
end

['Reseller 1', 'Reseller 2', 'Reseller 3', 'Reseller 4'].each do |name|
  Legal::HostingAbuse::ResellerPlan.create name: name
end

['Value', 'Business SSD', 'Business Expert', 'Professional', 'Ultimate', 'Email Only'].each do |name|
  Legal::HostingAbuse::SharedPlan.create name: name
end

['VPS Lite - Xen', 'VPS 1 - Xen', 'VPS 2 - Xen', 'VPS 3 - Xen'].each do |name|
  Legal::HostingAbuse::VpsPlan.create name: name
end

['Allow 6 Hours', 'Allow 12 Hours', 'Allow 24 Hours', 'Suspend Immediately', 'Already Suspended', 'Disable Email Forwarding', 'Suspend Permanently', 'Mitigated'].each do |name|
  Legal::HostingAbuse::Suggestion.create name: name
end


['HAProxy', 'HABlkctl (Extended HAProxy)', 'IP Tables', 'Other'].each do |name|
  Legal::HostingAbuse::Ddos::BlockType.create name: name
end


['CPU Usage', 'Memory Usage', 'Entry Processes', 'Input / Output', 'MySQL Queries', 'Number of (simultaneous) Processes Failed'].each do |name|
  Legal::HostingAbuse::Resource::AbuseType.create name: name
end

['Medium', 'High', 'Extremely High'].each do |name|
  Legal::HostingAbuse::Resource::Impact.create name: name
end

['Disc Space', 'LVE / MySQL', 'Cron Jobs'].each do |name|
  Legal::HostingAbuse::Resource::ResourceType.create name: name
end

['Business SSD', 'VPS 1 - XEN', 'VPS 2 - XEN', 'VPS 3 - XEN', 'Dedicated Server'].each do |name|
  Legal::HostingAbuse::Resource::Upgrade.create name: name
end

['Too Many', 'Too Often'].each do |name|
  Legal::HostingAbuse::Resource::ActivityType.create name: name
end

['Frequency of an active cron was reduced', 'Amount of simultaneous crons was reduced', 'Other'].each do |name|
  Legal::HostingAbuse::Resource::Measure.create name: name
end


["Queue", "Feedback loop (AOL, Microsoft, Comcast, etc.)", "Other"].each do |name|
  Legal::HostingAbuse::Spam::DetectionMethod.create name: name
end

["CAPTCHA related", "System Notifications", "Deliberate Spam", "Other (Marketing, Newsletter, etc.)"].each do |name|
  Legal::HostingAbuse::Spam::ContentType.create name: name
end

["Forwarded Emails", "Deliberate Spam", "Other (Marketing, Newsletter, etc.)"].each do |name|
  Legal::HostingAbuse::Spam::PeContentType.create name: name
end

["Outbound Emails", "Forwarded Emails", "Bounced Emails", "Logged Activity"].each do |name|
  Legal::HostingAbuse::Spam::QueueType.create name: name
end

["Emails Sent within a Time Frame", "Postfix Deferred Queue / Non-Deliverable", "Postfix Active Queue", "MAILER-DAEMON Bounced Emails"].each do |name|
  Legal::HostingAbuse::Spam::PeQueueType.create name: name
end

["AOL", "Blue Tie", "Comcast", "Cox", "FastMail", "HostedEmail", "Hotmail", "Microsoft", "PhoenixNAP","Rackspace", "Lashback",
 "ReturnPath", "RoadRunner", "SpamExperts", "Synacor", "Terra (Brazil)", "USA.net", "United Online", "Yahoo", "Zoho"].each do |name|
  Legal::HostingAbuse::Spam::ReportingParty.create name: name
end

[
  "Copyright / Trademark Infringement",
  "Adult Websites / Child Porn",
  "Terrorism / Violence / Hate Sites / Illegal Activities",
  "Drugs (Controlled Substances)",
  "Malware",
  "Port Scans / Brute Force / IP Scanners",
  "IRC bots",
  "Warez",
  "Torrents / Mirrors",
  "Streaming",
  "Proxy / Traffic Relaying Soft",
  "Banner-Ad Services / TopSites / AutoSurf Websites / etc.",
  "Escrow / HYIP / FOREX / E-Gold Exchange / etc.",
  "Gambling / Lottery Websites",
  "BitCoin Miners"
].each do |name|
  Legal::HostingAbuse::Other::AbuseType.create name: name
end