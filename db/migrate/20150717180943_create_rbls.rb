class CreateRbls < ActiveRecord::Migration
  def change
    create_table :rbls do |t|
      t.references :rbl_status
      t.string     :name
      t.string     :url

      t.timestamps null: false
    end
  end
end
