class Tools::InternalDomain < ActiveRecord::Base
  self.table_name = 'tools_internal_domains'

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, message: 'has already been added' }
  validate  :name_must_be_valid

  before_validation do
    self.name = self.name.downcase.strip
  end

  private

  def name_must_be_valid
    if name =~ /%/
      message = 'is invalid, example format: nmchp.% / %nmchp%.com / %nmchp.%'
      errors.add(:name, message) if name.split('.').count != 2
    else
      errors.add(:name, 'is invalid') unless PublicSuffix.valid?(name)
    end
  end

end
