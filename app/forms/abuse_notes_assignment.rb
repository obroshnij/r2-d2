class AbuseNotesAssignment
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :username, String
  attribute :domains,  Array[String]
  attribute :_destroy, Boolean
  
  validates :domains, presence: true
  
  def persistent?
    false
  end
  
  def username=(username)
    super username.try(:downcase).try(:strip)
  end
  
  def domains
    super.join(', ')
  end
  
  def domains_array
    @domains
  end
  
  def domains=(domains)
    super DomainName.parse_multiple(domains, remove_subdomains: true).map(&:name)
  end
  
end