class Tools::WhoisLookup
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :query, :record
  
  def initialize query
    @query  = query.downcase.strip
    @record = get_whois_record
  end
  
  private
  
  def get_whois_record
    Whois.lookup @query
  rescue => ex
    add_error ex.message
    nil
  end
  
  def add_error message
    message = 'is not a valid entry' if message.include?('is not a valid entry')
    errors.add :query, message
  end
  
end