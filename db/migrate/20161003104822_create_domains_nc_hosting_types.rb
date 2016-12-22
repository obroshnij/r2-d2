class CreateDomainsNcHostingTypes < ActiveRecord::Migration
  def change
    create_table :domains_nc_hosting_types do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
