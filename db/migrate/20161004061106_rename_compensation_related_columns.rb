class RenameCompensationRelatedColumns < ActiveRecord::Migration
  def change
    rename_column :domains_nc_services, :domains_namecheap_product_id,      :product_id
    rename_column :domains_nc_services, :domains_namecheap_hosting_type_id, :hosting_type_id
  end
end
