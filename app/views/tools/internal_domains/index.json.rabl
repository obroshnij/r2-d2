object false

child :@internal_domains => :items do
  extends 'tools/internal_domains/_base'
end

node :pagination do
  {
    totalRecords: @internal_domains.total_entries
  }
end
