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
  validates :rule,              presence: true, if: :ip_tables?
  validates :other_block_type,  presence: true, if: :other_block_type?
  
  def ip_tables?
    block_type_id == 3
  end
  
  def other_block_type?
    block_type_id == 4
  end
  
end