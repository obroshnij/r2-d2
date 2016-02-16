class Tools::ListsDiff
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :query_one, :query_two, :list_one, :list_two, :list_one_dup, :list_two_dup, :list_one_only, :list_two_only, :uniqe, :common
  
  validates :query_one, :query_two, presence: true
  
  def initialize query_one, query_two
    @query_one, @query_two = query_one, query_two
    compare_lists if valid?
  end
  
  private
  
  def compare_lists
    @list_one,     @list_two     = parse_list(query_one),      parse_list(query_two)
    @list_one_dup, @list_two_dup = find_duplicates(@list_one), find_duplicates(@list_two)
    @list_one.uniq!
    @list_two.uniq!
    
    @list_one_only = @list_one - @list_two
    @list_two_only = @list_two - @list_one
    @unique        = (@list_one + @list_two).uniq
    @common        = @unique.select { |el| @list_one.include?(el) && @list_two.include?(el) }
  end
  
  def parse_list query
    query.split("\n").map { |line| line.strip.downcase }
  end
  
  def find_duplicates list
    list.select { |el| list.count(el) > 1 }.uniq
  end
  
end