object false

child :@roles => :items do
  extends 'roles/_base'
end

node :pagination do
  {
    totalRecords: @roles.total_entries
  }
end