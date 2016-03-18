object false

child :@lookups => :items do
  attributes :id, :status, :domains, :successful, :failed, :created_at, :updated_at
end

node :pagination do
  {
    totalRecords: @lookups.total_entries
  }
end