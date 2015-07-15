class CreateServiceStatuses < ActiveRecord::Migration
  def change
    create_table :service_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
