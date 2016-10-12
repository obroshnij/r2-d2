object false

child :@compensations => :items do
  extends 'domains/compensations/_base'
end

node :pagination do
  {
    totalRecords: @compensations.total_entries
  }
end
