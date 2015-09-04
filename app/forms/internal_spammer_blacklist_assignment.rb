class InternalSpammerBlacklistAssignment
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :usernames,         String
  attribute :relation_type_ids, Array[Integer]
  
  validates :usernames, presence: true
  validates :usernames, format: { with: /\A[\w\d\s,]+\z/, multiline: true, message: "is (are) invalid" }, allow_nil: true
  
  def persisted?
    false
  end
  
end