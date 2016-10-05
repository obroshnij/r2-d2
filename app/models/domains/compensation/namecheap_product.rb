class Domains::Compensation::NamecheapProduct < ActiveRecord::Base
  self.table_name = 'domains_nc_products'

  has_many :services, class_name: 'Domains::Compensation::NamecheapService', foreign_key: 'product_id'
end
