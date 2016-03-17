Ransack.configure do |config|
  
  config.add_predicate 'arr_cont',
    wants_array: true,
    arel_predicate: 'contains',
    validator: proc { |v| v.present? }
    
  config.add_predicate 'datetime_between',
    wants_array: false,
    arel_predicate: 'in',
    formatter: proc { |v|
      dates = v.split(" - ").map { |d| Time.zone.parse d }
      dates.first.beginning_of_day..dates.last.end_of_day
    },
    validator: proc { |v| v.present? },
    type: :string
    
end