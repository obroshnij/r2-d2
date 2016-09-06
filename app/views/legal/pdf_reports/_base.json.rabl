attributes :id, :username, :edited_by_id

node(:created_by) do |r|
  r.created_by.try(:name)
end

node(:edited_by) do |r|
  r.edited_by.try(:name)
end

node(:created_at_formatted) do |r|
  r.created_at.strftime '%b/%d/%Y, %H:%M'
end

node(:updated_at_formatted) do |r|
  r.updated_at.strftime '%b/%d/%Y, %H:%M'
end

node(:pages_count) do |r|
  r.pages.keys.count
end

node(:expires_on_formatted) do |r|
  r.expires_on.strftime '%b/%d/%Y'
end
