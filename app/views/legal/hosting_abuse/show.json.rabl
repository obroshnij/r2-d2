object :@hosting_abuse

attributes :id, :reported_by_id, :service_id, :type_id, :shared_plan_id, :username

node(:reported_by)  { |h| h.reported_by.name }
node(:service)      { |h| h.service.name }
node(:type)         { |h| h.type.name }