object false

child :@nc_users => :items do
  extends 'legal/nc_users/_base'
end

node :pagination do
  {
    totalRecords: @nc_users.total_entries
  }
end
