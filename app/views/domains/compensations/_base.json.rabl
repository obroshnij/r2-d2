attrs = Domains::Compensation.attribute_names - ['checked_by_id', 'used_correctly', 'delivered', 'qa_comments']
attributes *attrs

node(:submitted_by)                                                  { |c| c.submitted_by.name }
node(:product)                                                       { |c| c.product.name }
node(:product_compensated)                                           { |c| c.product_compensated.name }
node(:service_compensated, if: -> (c) { c.service_compensated_id })  { |c| c.service_compensated.name }
node(:hosting_type,        if: -> (c) { c.hosting_type_id })         { |c| c.hosting_type.name }
node(:issue_level)                                                   { |c| c.issue_level.name }
node(:compensation_type)                                             { |c| c.compensation_type.name }
node(:tier_pricing,        if: -> (c) { c.tier_pricing_id })         { |c| c.tier_pricing.name }
node(:created_at_formatted)                                          { |c| c.created_at.strftime '%b/%d/%Y, %H:%M' }

node(:checked_by_id,       if: -> (c) { qa?(c) })                    { |c| c.checked_by_id }
node(:checked_by,          if: -> (c) { qa?(c) && c.checked_by_id }) { |c| c.checked_by.name }
node(:used_correctly,      if: -> (c) { qa?(c) })                    { |c| c.used_correctly }
node(:delivered,           if: -> (c) { qa?(c) })                    { |c| c.delivered }
node(:qa_comments,         if: -> (c) { qa?(c) })                    { |c| c.qa_comments }
