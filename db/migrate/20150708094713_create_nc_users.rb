class CreateNcUsers < ActiveRecord::Migration
  def change
    create_table :nc_users do |t|
      t.string  :username
      t.integer :status_ids, array: true, default: []
      t.date    :signed_up_on

      t.timestamps null: false
    end
  end
end
