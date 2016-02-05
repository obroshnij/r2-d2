attributes  :id,
            :reported_by_id,
            :processed_by_id,
            :processed,
            :service_id,
            :type_id,
            :server_id,
            :username,
            :resold_username,
            :management_type_id,
            :reseller_plan_id,
            :shared_plan_id,
            :server_rack_label,
            :subscription_name,
            :suggestion_id,
            :suspension_reason,
            :scan_report_path,
            :tech_comments,
            :legal_comments,
            :ticket_id,
            :created_at,
            :updated_at

node(:reported_by)                                         { |h| h.reported_by.name }
node(:service)                                             { |h| h.service.name }
node(:type)                                                { |h| h.type.name }
node(:created_at_formatted)                                { |h| h.created_at.strftime '%d %b %Y, %H:%M' }
node(:processed_by,           if: -> (h) { h.processed })  { |h| h.processed_by.name }
node(:processed_at_formatted, if: -> (h) { h.processed })  { |h| h.processed_at.strftime '%d %b %Y, %H:%M' }
node(:server_name,            if: -> (h) { h.server_id })  { |h| h.server.name }
node(:suggestion)                                          { |h| h.suggestion.name }