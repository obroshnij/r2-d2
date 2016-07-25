class Tools::InternalDomain < ActiveRecord::Base
  self.table_name = 'tools_internal_domains'

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, message: 'has already been added' }

  before_validation do
    self.name = self.name.downcase.strip
  end

end
