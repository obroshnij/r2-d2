object false

child :@lookups => :items do
  attributes :id, :status, :domains_count, :successful_count, :failed_count, :created_at, :updated_at
end

node :pagination do
  {
    totalRecords: @lookups.total_entries
  }
end