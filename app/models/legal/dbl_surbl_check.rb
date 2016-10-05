class Legal::DblSurblCheck
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :query, :domains, :records

  validates :query, presence: true

  def initialize query
    @query   = query.downcase.strip
    @domains = DomainName.parse_multiple @query
    @records = check_domains if valid?
  end

  private

  def check_domains
    DNS::SpamBase.check_multiple @domains
    @domains.map do |domain|
      {
        host_name: domain.name,
        dbl:       domain.extra_attr[:dbl],
        surbl:     domain.extra_attr[:surbl]
      }
    end
  rescue => ex
    add_error ex.message
    nil
  end

  def add_error message
    message = 'is not a valid entry' if message.include?('is not a valid entry')
    errors.add :query, message
  end

end