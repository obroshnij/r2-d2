attributes :id, :name, :comment, :created_at, :updated_at

node(:created_at_formatted) do |d|
  d.created_at.strftime '%b/%d/%Y, %H:%M'
end

node(:updated_at_formatted) do |d|
  d.updated_at.strftime '%b/%d/%Y, %H:%M'
end
