class Domains::NamecheapService < ActiveRecord::Base
  self.table_name = 'domains_nc_services'

  belongs_to :product,      class_name: 'Domains::NamecheapProduct',     foreign_key: 'product_id'
  belongs_to :hosting_type, class_name: 'Domains::NamecheapHostingType', foreign_key: 'hosting_type_id'
end
