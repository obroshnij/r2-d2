class CreateDomainsNcProducts < ActiveRecord::Migration
  def change
    create_table :domains_nc_products do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
