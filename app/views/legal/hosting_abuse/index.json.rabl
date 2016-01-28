object false

child :@hosting_abuse => :items do
  extends 'legal/hosting_abuse/_base'
end

node :pagination do
  {
    totalRecords: @hosting_abuse.total_entries
  }
end