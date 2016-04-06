object false

child :@rbls => :items do
  extends 'legal/rbls/_base'
end

node :pagination do
  {
    totalRecords: @rbls.total_entries
  }
end