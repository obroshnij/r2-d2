class Legal::HostingAbuse::Form::Ddos
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :domain_port,       String
  attribute :block_type_id,     Integer
  attribute :rule,              String
  attribute :other_block_type,  String
  attribute :logs,              String
  
  validates :domain_port,       presence: true
  validates :logs,              presence: true
  validates :other_block_type,  presence: true, if: :other_block_type?
  
  def other_block_type?
    block_type_id == 5
  end
  
end