Ransack.configure do |config|
  
  config.add_predicate 'arr_cont',
    wants_array: true,
    arel_predicate: 'contains',
    validator: proc { |v| v.present? }
    
end