attributes *Legal::HostingAbuse.attribute_names

node(:reported_by)                                                        { |h| h.reported_by.name }
node(:service)                                                            { |h| h.service.name }
node(:service_url,            if: -> (h) { h.service.properties['url'] }) { |h| h.service.properties['url'] }
node(:type)                                                               { |h| h.type.name }
node(:created_at_formatted)                                               { |h| h.created_at.strftime '%b/%d/%Y, %H:%M' }
node(:server_name,            if: -> (h) { h.server_id })                 { |h| h.server.name }
node(:efwd_server_name,       if: -> (h) { h.efwd_server_id })            { |h| h.efwd_server.name }
node(:suggestion)                                                         { |h| h.suggestion.name }
node(:decision)                                                           { |h| h.decision.name }
node(:shared_plan,            if: -> (h) { h.shared_plan_id })            { |h| h.shared_plan.name }
node(:reseller_plan,          if: -> (h) { h.reseller_plan_id })          { |h| h.reseller_plan.name }
node(:vps_plan,               if: -> (h) { h.vps_plan_id })               { |h| h.vps_plan.name }
node(:management_type,        if: -> (h) { h.management_type_id })        { |h| h.management_type.name }
node(:canned_reply)                                                       { |h| h.canned_reply }
node(:uber_note)                                                          { |h| h.uber_note }
node(:ticket_identifier,      if: -> (h) { h.ticket_id })                 { |h| h.ticket.identifier }
node(:ticket_reports_count,   if: -> (h) { h.ticket_id })                 { |h| h.ticket.hosting_abuse_count }
node(:nc_username,            if: -> (h) { h.nc_user_id })                { |h| h.nc_user.username }
node(:uber_service_identifier, if: -> (h) { h.uber_service_id })          { |h| h.uber_service.identifier }

node(:nc_user_signup, if: -> (h) { h.service_id == 5 && h._processed? }) do |h|
  h.nc_user.signed_up_on.try(:strftime, '%d %B %Y')
end

node(:pe_suspended, if: -> (h) { h.service_id == 5 && h._processed? }) do |h|
  PrivateEmailInfo.where(hosting_abuse_id: h.id).first.try(:suspended)
end

node(:canned_attach_path, if: -> (h) { h.canned_attach.present? }) do |h|
  show_attach_legal_hosting_abuse_path h
end

child(:logs) do
  attributes :comment, :action

  node(:done_by)              { |l| l.user.name }
  node(:created_at_formatted) { |l| l.created_at.strftime '%b/%d/%Y, %H:%M' }
end

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
  attributes *(Legal::HostingAbuse::Resource.attribute_names + [:abuse_type_ids, :activity_type_ids, :measure_ids])

  node(:type, if: -> (r) { r.type_id }) do |r|
    r.type.name
  end

  node(:abuse_types, if: -> (r) { r.abuse_type_ids.present? }) do |r|
    r.abuse_types.map(&:name)
  end

  node(:disk_abuse_type, if: -> (r) { r.disk_abuse_type_id }) do |r|
    r.disk_abuse_type.name
  end

  node(:upgrade, if: -> (r) { r.upgrade_id }) do |r|
    r.upgrade.name
  end

  node(:impact, if: -> (r) { r.impact_id }) do |r|
    r.impact.name
  end

  node(:activity_types, if: -> (r) { r.activity_type_ids.present? }) do |r|
    r.activity_types.map(&:name)
  end

  node(:measures, if: -> (r) { r.measure_ids.present? }) do |r|
    r.measures.map(&:name)
  end

  node(:resource_consuming_websites) do |r|
    r.resource_consuming_websites.join("\n")
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

child(:pe_spam) do
  attributes *(Legal::HostingAbuse::PeSpam.attribute_names + [:pe_queue_type_ids, :reporting_party_ids])

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

  node(:pe_queue_types, if: -> (s) { s.pe_queue_type_ids.present? }) do |s|
    s.pe_queue_types.map(&:name)
  end

  node(:pe_content_type, if: -> (s) { s.pe_content_type_id.present? }) do |s|
    s.pe_content_type.name
  end
end

child(:other) do
  attributes *(Legal::HostingAbuse::Other.attribute_names + [:abuse_type_ids])

  node(:abuse_types, if: -> (o) { o.abuse_type_ids.present? }) do |o|
    o.abuse_types.map(&:name)
  end
end
