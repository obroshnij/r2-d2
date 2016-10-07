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

###############################################################################

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


['HAProxy', 'HABlkctl (Extended HAProxy)', 'IP Tables / IPtablock', 'Other'].each do |name|
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

###############################################################################

Domains::NamecheapProduct.create(name: "Domains")
hosting = Domains::NamecheapProduct.create(name: "Hosting")
ncpe = Domains::NamecheapProduct.create(name: "NCPE")
ssl_namecheap = Domains::NamecheapProduct.create(name: "SSL (Namecheap.com)")
ssl_ssls_com = Domains::NamecheapProduct.create(name: "SSL (SSLs.com)")
ssl_sslsertificate_com = Domains::NamecheapProduct.create(name: "SSLcertificate.com")
Domains::NamecheapProduct.create(name: "WhoisGuard")
Domains::NamecheapProduct.create(name: "PremiumDNS")
apps = Domains::NamecheapProduct.create(name: "Apps")
Domains::NamecheapProduct.create(name: "Credit (funds added to account balance)")

shared_plans = Domains::NamecheapHostingType.create(name: "Shared Plans")
vps_plans = Domains::NamecheapHostingType.create(name: "VPS Plans")
dedicated_servers = Domains::NamecheapHostingType.create(name: "Dedicated servers")
addons = Domains::NamecheapHostingType.create(name: "Addons")

[
  "Value 4G",
  "Professional 4G",
  "Ultimate 4G",
  "Business SSD",
  "Level 1 Reseller",
  "Level 2 Reseller",
  "Level 3 Reseller",
  "Level 4 Reseller",
  "Older Shared Plans"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: hosting.id, hosting_type_id: shared_plans.id)
end

[
  "Xeon E3-1220 8 500GB SATA",
  "Xeon E3-1220 8 300GB SSD",
  "Xeon E3-1240 8 SATA",
  "Xeon E3-1240 16 2xSATA",
  "Xeon E3-1240 8 SSD",
  "Xeon E3-1240 16 2xSSD",
  "Xeon E3-1270 8 SATA",
  "Xeon E3-1270 16 2xSATA",
  "Xeon E3-1270 8 SSD",
  "Xeon E3-1270 16 2xSSD",
  "Xeon E5-2609 16 SATA",
  "Xeon E5-2609 32 2xSATA",
  "Xeon E5-2609 16 SSD",
  "Xeon E5-2609 32 2xSSD",
  "Xeon E5-2620 32 2xSATA",
  "Xeon E5-2620 64 4xSATA",
  "Xeon E5-2620 32 2xSSD",
  "Xeon E5-2620 64 4xSSD",
  "Older Dedicated Servers"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: hosting.id, hosting_type_id: dedicated_servers.id)
end

[
  "VPS Lite - Xen",
  "VPS 1 - Xen",
  "VPS 2 - Xen",
  "VPS 3 - Xen"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: hosting.id, hosting_type_id: vps_plans.id)
end

[
  "Dedicated IP",
  "Backup Fee",
  "WHMCS",
  "Additional Disk Space",
  "cPanel",
  "Softaculous",
  "CloudLinux OS",
  "Managed Plan",
  "Fully Managed Plan",
  "RAM",
  "Disk Space",
  "Bandwidth",
  "Uplink Port",
  "Branding Removal for WHMCS",
  "CXS License",
  "Emergency Assistance"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: hosting.id, hosting_type_id: addons.id)
end

[
  "Private",
  "Business",
  "Business Office",
  "Additional Mailbox",
  "Older NCPE"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: ncpe.id)
end

[
  "PositiveSSL",
  "PositiveSSL Wildcard",
  "PositiveSSL Multi-Domain",
  "EssentialSSL",
  "EssentialSSL Wildcard",
  "RapidSSL",
  "RapidSSL Wildcard",
  "QuickSSL Premium",
  "Thawte SSL 123",
  "InstantSSL",
  "InstantSSL Pro",
  "PremiumSSL",
  "PremiumSSL Wildcard",
  "Multi-Domain SSL",
  "Unified Communications",
  "True BusinessID",
  "True BusinessID Wildcard",
  "True BusinessID Multi-Domain",
  "Secure Site",
  "Secure Site Pro",
  "SSL Web Server",
  "EV SSL",
  "EV Multi-Domain SSL",
  "True BusinessID with EV",
  "True BusinessID with EV Multi-Domain",
  "Secure Site with EV",
  "Secure Site Pro with EV",
  "SSL Web Server EV"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: ssl_namecheap.id)
end

[
  "PositiveSSL",
  "EssentialSSL",
  "PositiveSSL Wildcard",
  "EssentialSSL Wildcard",
  "PositiveSSL Multi-Domain",
  "InstantSSL",
  "InstantSSL Pro",
  "PremiumSSL",
  "PremiumSSL Wildcard",
  "Unified Communications",
  "Multi-Domain SSL",
  "EV SSL",
  "EV Multi-Domain SSL",
  "RapidSSL",
  "RapidSSL Wildcard",
  "QuickSSL Premium",
  "True BusinessID",
  "True BusinessID with EV",
  "True BusinessID Wildcard",
  "Secure Site",
  "Secure Site Pro",
  "Secure Site Pro with EV",
  "Secure Site with EV",
  "SSL123",
  "SSL Web Server",
  "SSL Web Server EV"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: ssl_ssls_com.id)
end

[
  "PositiveSSL",
  "EssentialSSL",
  "PositiveSSL Wildcard",
  "EssentialSSL Wildcard",
  "InstantSSL",
  "InstantSSL Pro",
  "PremiumSSL",
  "PremiumSSL Wildcard",
  "EV SSL",
  "RapidSSL",
  "RapidSSL Wildcard",
  "QuickSSL Premium",
  "True BusinessID",
  "True BusinessID Wildcard",
  "True BusinessID with EV",
  "Secure Site",
  "Secure Site Pro",
  "Secure Site Pro with EV",
  "Secure Site with EV",
  "SSL123",
  "SSL Web Server",
  "SSL Web Server EV"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: ssl_sslsertificate_com.id)
end

[
  "Strikingly",
  "Weebly",
  "Namecheap Uptime Monitoring",
  "Namecheap Legal",
  "Canvas",
  "Bablic",
  "Nimbusec",
  "MarketGoo",
  "SiteBooster",
  "Google Apps For Work",
  "Vigil"
].each do |name|
  Domains::NamecheapService.create(name: name, product_id: apps.id)
end

[
  "1 - 'Subjective' issues",
  "2 - System bugs",
  "3 - Human factor errors / Service not working as expected"
].each do |name|
  Domains::Compensation::IssueLevel.create name: name
end

[
  "Discount",
  "Free item",
  "Service prolongation",
  "Refund",
  "Fee concession",
  "Credit",
  "Tier pricing assginment"
].each do |name|
  Domains::Compensation::CompensationType.create name: name
end

[
  "50 Active Domains",
  "100 Active Domains",
  "300 Active Domains",
  "500 Active Domains",
  "800 Active Domains"
].each do |name|
  Domains::Compensation::TierPricing.create name: name
end
