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

['Shared Package', 'Reseller Package', 'VPS Hosting', 'Dedicated Server', 'Private Email'].each do |name|
  Legal::HostingAbuse::Service.create name: name
end

['Email Abuse / Spam', 'Resource Abuse', 'DDoS'].each do |name|
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

['6 Hours', '12 Hours', '24 Hours', 'To Suspend', 'Already Suspended'].each do |name|
  Legal::HostingAbuse::Suggestion.create name: name
end


['HAProxy', 'HABlkctl (Extended HAProxy)', 'IP Tables', 'Rule', 'Other'].each do |name|
  Legal::HostingAbuse::Ddos::BlockType.create name: name
end


['CPU Usage', 'Memory Usage', 'Entry Processes', 'Input / Output', 'MySQL Queries', 'Number of (simultaneous) Processes Failed'].each do |name|
  Legal::HostingAbuse::Resource::AbuseType.create name: name
end

['Too Many', 'Too Often'].each do |name|
  Legal::HostingAbuse::Resource::ActivityType.create name: name
end

['Medium', 'High', 'Extremely High'].each do |name|
  Legal::HostingAbuse::Resource::Impact.create name: name
end

['Frequency of an active cron was reduced', 'Amount of simultaneous crons was reduced', 'Other'].each do |name|
  Legal::HostingAbuse::Resource::Measure.create name: name
end

['Cron Jobs', 'Disc Space', 'LVE / MySQL'].each do |name|
  Legal::HostingAbuse::Resource::ResourceType.create name: name
end

['Business SSD', 'VPS 1 - XEN', 'VPS 2 - XEN', 'VPS 3 - XEN', 'Dedicated Server'].each do |name|
  Legal::HostingAbuse::Resource::Upgrade.create name: name
end


["Queue", "Feedback loop (AOL, Microsoft, Comcast, etc.)", "Other"].each do |name|
  Legal::HostingAbuse::Spam::DetectionMethod.create name: name
end

["Outbound Emails", "Bounced Emails", "CAPTCHA related", "Forwarded Emails", "System Notifications", "Deliberate Spam"].each do |name|
  Legal::HostingAbuse::Spam::QueueType.create name: name
end

["AOL", "Blue Tie", "Comcast", "Cox", "FastMail", "HostedEmail", "Hotmail", "Microsoft", "PhoenixNAP","Rackspace",
 "ReturnPath", "RoadRunner", "SpamExperts", "Synacor", "Terra (Brazil)", "USA.net", "United Online", "Yahoo", "Zoho"].each do |name|
  Legal::HostingAbuse::Spam::ReportingParty.create name: name
end