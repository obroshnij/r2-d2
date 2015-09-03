class DnsDdosAssignment
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :username,           String
  # attribute :new_status,         Integer
  attribute :registered_domains, Integer
  attribute :free_dns_domains,   Integer
  attribute :comment,            String
  attribute :relation_type_ids,  Array[Integer]
  attribute :_destroy,           Boolean
  
  def persisted?
    false
  end
  
end