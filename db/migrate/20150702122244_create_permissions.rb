class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :role
      t.string     :subject_class
      t.string     :actions, array: true
      t.integer    :subject_ids, array: true
      
      t.timestamps null: false
    end
  end
end
