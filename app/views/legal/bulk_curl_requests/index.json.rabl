object false

child :@requests => :items do
  attributes :id, :status, :urls, :results, :created_at, :updated_at
end

node :pagination do
  {
    totalRecords: @requests.total_entries
  }
end