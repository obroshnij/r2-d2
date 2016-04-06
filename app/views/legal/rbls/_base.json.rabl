attributes :id, :name, :url, :rbl_status_id, :comment

node(:status_name) do |r|
  r.status.name
end