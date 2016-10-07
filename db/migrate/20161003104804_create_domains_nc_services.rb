class CreateDomainsNcServices < ActiveRecord::Migration
  def change
    create_table :domains_nc_services do |t|
      t.string :name
      t.belongs_to :domains_namecheap_product
      t.belongs_to :domains_namecheap_hosting_type
      t.boolean :hidden, default: false
      t.timestamps null: false
    end
  end
end
