class Tools::ListsDiff
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  def initialize query_one, query_two
    @list_one, @list_two = parse_list(query_one), parse_list(query_two)
    
  end
  
  private
  
  def parse_list query
    query.split("\r\n").map { |line| line.strip.downcase }
  end
  
end