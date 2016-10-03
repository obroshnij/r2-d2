class Domains::NamecheapProduct < ActiveRecord::Base
  self.table_name = 'domains_nc_products'
  has_many :domains_namecheap_services, :class_name => 'Domains::NamecheapService'
end
