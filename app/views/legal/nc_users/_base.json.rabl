attributes :id, :username, :status_ids, :status_names

node(:signed_up_on) do |r|
  r.signed_up_on.try(:strftime, "%d %B %Y").to_s
end

node(:abuse_reports_direct) do |r|
  r.abuse_reports.direct.map do |ar|
    { type: ar.try(:name), reporter_name: User.find(ar.reported_by).name, created_at: ar.created_at.strftime("%d %B %Y at %H:%M"), is_processed: ar.processed ? 'Yes' : 'No'  }
  end
end

node(:abuse_reports_indirect) do |r|
  r.abuse_reports.indirect.map do |ar|
    { type: ar.abuse_report_type.try(:name), reporter_name: User.find(ar.reported_by).name, created_at: ar.created_at.strftime("%d %B %Y at %H:%M"), is_processed: ar.processed ? 'Yes' : 'No', reportable_name: ar.reportable_name  }
  end
end