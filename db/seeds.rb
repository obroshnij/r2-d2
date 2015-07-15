# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w{ Spammer }.each do |name|
  AbuseReportType.create name: name
end

%w{ Spammer Internal\ Account Has\ VIP\ Domains }.each do |name|
  Status.create name: name
end

%w{ IP\ Address Payment Password }.each do |name|
  RelationType.create name: name
end

%w{ Domain }.each do |name|
  NcServiceType.create name: name
end

%w{ VIP }.each do |name|
  ServiceStatus.create name: name
end