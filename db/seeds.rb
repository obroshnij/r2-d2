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