class Legal::HostingAbuse::Form::Ddos
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_accessor :service_id
  
  attribute :domain_port,       String
  attribute :inbound,           Boolean
  attribute :block_type_id,     Integer
  attribute :rule,              String
  attribute :other_block_type,  String
  attribute :logs,              String
  
  validates :domain_port,       presence: true, if: :shared_reseller?
  validates :logs,              presence: true
  
  validates :rule,              presence: true, if: -> { shared_reseller? && ip_tables?        || vps_dedicated? && inbound && ip_tables? }
  validates :other_block_type,  presence: true, if: -> { shared_reseller? && other_block_type? || vps_dedicated? && inbound && other_block_type? }
  
  def shared_reseller?
    [1, 2].include? service_id
  end
  
  def vps_dedicated?
    [3, 4].include? service_id
  end
  
  def ip_tables?
    block_type_id == 3
  end
  
  def other_block_type?
    block_type_id == 4
  end
  
end