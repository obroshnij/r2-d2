class DnsDdosAssignment
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :username,           String
  attribute :registered_domains, Integer
  attribute :free_dns_domains,   Integer
  attribute :comment,            String
  attribute :relation_type_ids,  Array[Integer]
  attribute :_destroy,           Boolean
  
  validates :username, :registered_domains, :free_dns_domains, presence: true
  validates :registered_domains, :free_dns_domains, numericality: { only_integer: true }
  validates :username, format: { with: /\A[\w\d]+\z/, message: "is invalid" }
  
  def persisted?
    false
  end
  
  def relation_type_ids=(ids)
    super ids.delete_if(&:blank?)
  end
  
  def username=(username)
    super username.try(:downcase).try(:strip)
  end
  
end