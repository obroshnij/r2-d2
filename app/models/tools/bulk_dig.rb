class Tools::BulkDig
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :query, :record_types, :nameservers, :records
  
  validates :query, presence: true
  
  def initialize query, record_types, nameservers
    @query        = query
    @record_types = record_types.all?(&:blank?) ? [:a, :mx, :ns] : record_types.map(&:to_sym).delete_if(&:blank?)
    @nameservers  = nameservers.to_sym
    @records      = get_records if valid?
  end
  
  private
  
  def get_records
    domains = DomainName.parse_multiple @query
    errors.add(:query, 'No valid host names found') and return if domains.blank?
    
    DNS::Resolver.dig_multiple domains, type: @nameservers, records: @record_types
    domains.map do |domain|
      { host_name: domain.name, records: domain.extra_attr[:host_records] }
    end
  end
  
end