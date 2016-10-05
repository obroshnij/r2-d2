class DblSublChecker
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :query, :domains, :records

  validates :query, presence: true

  def initialize query
    @query   = query.downcase.strip
    @domains = DomainName.parse_multiple @query
    @records = check_domains if valid?
    spam_base if @domains.any?
  end

  private

  def check_domains
    DNS::Resolver.dig_multiple @domains
    @domains.map do |domain|
      {
        host_name: domain.name,
        dbl:       domain.extra_attr.key?(:dbl)? 'Yes' : 'No',
        surbl:     domain.extra_attr.key?(:surbl)? 'Yes' : 'No'
      }
    end
  rescue => ex
    add_error ex.message
    nil
  end

  def spam_base
    DNS::SpamBase.check_multiple @domains
  end

  def add_error message
    message = 'is not a valid entry' if message.include?('is not a valid entry')
    errors.add :query, message
  end

end