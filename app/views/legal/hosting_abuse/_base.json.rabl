attributes *Legal::HostingAbuse.attribute_names

node(:reported_by)                                                      { |h| h.reported_by.name }
node(:service)                                                          { |h| h.service.name }
node(:type)                                                             { |h| h.type.name }
node(:created_at_formatted)                                             { |h| h.created_at.strftime '%d %b %Y, %H:%M' }
node(:processed_by,           if: -> (h) { !h.unprocessed? })           { |h| h.processed_by.name }
node(:processed_at_formatted, if: -> (h) { !h.unprocessed? })           { |h| h.processed_at.strftime '%d %b %Y, %H:%M' }
node(:server_name,            if: -> (h) { h.server_id })               { |h| h.server.name }
node(:efwd_server_name,       if: -> (h) { h.efwd_server_id })          { |h| h.efwd_server.name }
node(:suggestion)                                                       { |h| h.suggestion.name }
node(:shared_plan,            if: -> (h) { h.shared_plan_id })          { |h| h.shared_plan.name }
node(:reseller_plan,          if: -> (h) { h.reseller_plan_id })        { |h| h.reseller_plan.name }
node(:management_type,        if: -> (h) { h.management_type_id })      { |h| h.management_type.name }

child(:ddos) do
  attributes *Legal::HostingAbuse::Ddos.attribute_names
  
  node(:direction, if: -> (d) { !d.inbound.nil? }) do |d|
    d.inbound ? 'Inbound' : 'Outbound'
  end
  
  node(:block_type, if: -> (d) { d.block_type_id }) do |d|
    d.block_type.name
  end
end

child(:resource) do
  attributes *(Legal::HostingAbuse::Resource.attribute_names + [:abuse_type_ids])
  
  node(:type, if: -> (r) { r.type_id }) do |r|
    r.type.name
  end
  
  node(:abuse_types, if: -> (r) { r.abuse_type_ids.present? }) do |r|
    r.abuse_types.map(&:name)
  end
  
  node(:upgrade, if: -> (r) { r.upgrade_id }) do |r|
    r.upgrade.name
  end
  
  node(:impact, if: -> (r) { r.impact_id }) do |r|
    r.impact.name
  end
end

child(:spam) do
  attributes *(Legal::HostingAbuse::Spam.attribute_names + [:queue_type_ids, :reporting_party_ids])
  
  node(:sent_emails_daterange, if: -> (s) { s.sent_emails_start_date.present? && s.sent_emails_end_date.present? }) do |s|
    s.sent_emails_start_date.strftime('%d %B %Y') + ' - ' + s.sent_emails_end_date.strftime('%d %B %Y')
  end
  
  node(:sent_emails_daterange_short, if: -> (s) { s.sent_emails_start_date.present? && s.sent_emails_end_date.present? }) do |s|
    s.sent_emails_start_date.strftime('%d %b %Y') + ' - ' + s.sent_emails_end_date.strftime('%d %b %Y')
  end
  
  node(:detected_by) do |s|
    s.detection_method.name
  end
  
  node(:reporting_parties, if: -> (s) { s.reporting_party_ids.present? }) do |s|
    s.reporting_parties.map(&:name)
  end
  
  node(:content_type, if: -> (s) { s.content_type_id }) do |s|
    s.content_type.name
  end
  
  node(:queue_types, if: -> (s) { s.queue_type_ids.present? }) do |s|
    s.queue_types.map(&:name)
  end
end