class Domains::NamecheapHostingType < ActiveRecord::Base
  self.table_name = 'domains_nc_hosting_types'
  has_many :domains_namecheap_services, :class_name => 'Domains::NamecheapService'
end
