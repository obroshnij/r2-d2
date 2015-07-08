class CreateNcServiceTypes < ActiveRecord::Migration
  def change
    create_table :nc_service_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
