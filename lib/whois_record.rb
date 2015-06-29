class WhoisRecord
  
  attr_accessor :record, :properties
  
  def initialize(domain_name, record)
    @record = record
    @properties = @record.present? ? WhoisParser.parse(domain_name, @record) : nil
  end
  
  def to_s
    @record
  end
  
end