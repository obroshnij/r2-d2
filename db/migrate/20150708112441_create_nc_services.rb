class CreateNcServices < ActiveRecord::Migration
  def change
    create_table :nc_services do |t|
      t.references :nc_user
      t.references :nc_service_type
      t.string     :name
      
      t.timestamps null: false
    end
  end
end
