class Domains::NamecheapHostingType < ActiveRecord::Base
  self.table_name = 'domains_nc_hosting_types'

  has_many :services, class_name: 'Domains::NamecheapService', foreign_key: 'hosting_type_id'
end
