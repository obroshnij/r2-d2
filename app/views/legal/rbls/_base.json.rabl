attributes :id, :name, :url, :rbl_status_id, :comment

node(:status_name) do |r|
  r.status.name
end

node(:created_at_formatted) do |r|
  r.created_at.strftime '%b/%d/%Y, %H:%M'
end

node(:updated_at_formatted) do |r|
  r.updated_at.strftime '%b/%d/%Y, %H:%M'
end
