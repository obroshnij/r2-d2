class Legal::Rbl::Checker
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :ip_address, :result
  
  validates :ip_address, presence: true, ip_address: true
  
  def initialize ip_address
    @ip_address = ip_address.strip
    perform_check if valid?
  end
  
  private
  
  def perform_check
    @result = []
    split_by_checkers.each do |checker, rbls|
      @result += checker.new.check(ip_address, rbls)
    end
  end
  
  def split_by_checkers
    rbls = Legal::Rbl.all
    rbls.each_with_object({}) do |rbl, hash|
      checker_class = get_checker rbl.data['checker_type']
      hash[checker_class] ||= []
      hash[checker_class]  << rbl
    end
  end
  
  def get_checker checker_type
    return Legal::Rbl::Checker::Skip if checker_type.blank?
    
    klass = checker_type.split(':').map(&:capitalize).join
    "Legal::Rbl::Checker::#{klass}".constantize rescue Legal::Rbl::Checker::Skip
  end
  
end