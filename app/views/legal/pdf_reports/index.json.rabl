object false

child :@reports => :items do
  extends 'legal/pdf_reports/_base'
end

node :pagination do
  {
    totalRecords: @reports.total_entries
  }
end
