class CreateRblStatuses < ActiveRecord::Migration
  def change
    create_table :rbl_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
