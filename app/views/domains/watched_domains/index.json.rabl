object false

child :@watched_domains => :items do
  extends 'domains/watched_domains/_base'
end

node :pagination do
  {
    totalRecords: @watched_domains.total_entries
  }
end