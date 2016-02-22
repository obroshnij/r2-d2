object false

child :@users => :items do
  extends 'users/_base'
end

node :pagination do
  {
    totalRecords: @users.total_entries
  }
end