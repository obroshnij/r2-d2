# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w{ Spammer DDoS Private\ Email Abuse\ Notes }.each do |name|
  AbuseReportType.create name: name
end

%w{ Spammer DDoSer Internal\ Account Has\ VIP\ Domains }.each do |name|
  Status.create name: name
end

%w{ IP\ Address Payment Password }.each do |name|
  RelationType.create name: name
end

%w{ Domain Private\ Email }.each do |name|
  NcServiceType.create name: name
end

%w{ VIP }.each do |name|
  ServiceStatus.create name: name
end

%w{ main related }.each do |name|
  ReportAssignmentType.create name: name
end