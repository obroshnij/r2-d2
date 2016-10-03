class Domains::NamecheapService < ActiveRecord::Base
  self.table_name = 'domains_nc_services'

  belongs_to :domains_namecheap_products, :class_name => 'Domains::NamecheapProduct', foreign_key: :domains_namecheap_product_id
  belongs_to :domains_namecheap_hosting_types, :class_name => 'Domains::NamecheapHostingType', foreign_key: :domains_namecheap_hosting_type_id
end
