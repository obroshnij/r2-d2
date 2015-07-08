class CreateNcUsers < ActiveRecord::Migration
  def change
    create_table :nc_users do |t|
      t.references :status
      t.string :username
      t.date   :signed_up_on

      t.timestamps null: false
    end
  end
end
