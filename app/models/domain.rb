class Domain

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name

  def persisted?
    false
  end

  def initialize(str)
    @domain_name = PublicSuffix.parse(str)
  end

  def domain
    @domain_name.domain
  end

  def whois
    Whois.whois("#{domain}")
  end

end