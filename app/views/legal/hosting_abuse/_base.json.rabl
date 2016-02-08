attributes *Legal::HostingAbuse.attribute_names

node(:reported_by)                                                      { |h| h.reported_by.name }
node(:service)                                                          { |h| h.service.name }
node(:type)                                                             { |h| h.type.name }
node(:created_at_formatted)                                             { |h| h.created_at.strftime '%d %b %Y, %H:%M' }
node(:processed_by,           if: -> (h) { !h.unprocessed? })           { |h| h.processed_by.name }
node(:processed_at_formatted, if: -> (h) { !h.unprocessed? })           { |h| h.processed_at.strftime '%d %b %Y, %H:%M' }
node(:server_name,            if: -> (h) { h.server_id })               { |h| h.server.name }
node(:suggestion)                                                       { |h| h.suggestion.name }

child(:ddos) do
  attributes *Legal::HostingAbuse::Resource.attribute_names
end

child(:resource) do
  attributes *(Legal::HostingAbuse::Resource.attribute_names + [:abuse_type_ids])
end

child(:spam) do
  attributes *(Legal::HostingAbuse::Spam.attribute_names + [:queue_type_ids, :reporting_party_ids])
  
  node(:sent_emails_daterange, if: -> (s) { s.sent_emails_start_date.present? && s.sent_emails_end_date.present? }) do |s|
    s.sent_emails_start_date.strftime('%d %B %Y') + ' - ' + s.sent_emails_end_date.strftime('%d %B %Y')
  end
end