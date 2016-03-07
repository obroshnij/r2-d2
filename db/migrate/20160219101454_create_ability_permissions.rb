class CreateAbilityPermissions < ActiveRecord::Migration
  def change
    create_table :ability_permissions do |t|
      t.integer :resource_id
      t.string  :identifier
      t.string  :actions,    array: true, default: []
      t.string  :conditions,              default: ''
      t.jsonb   :attrs,                   default: {}
      
      t.timestamps null: false
    end
    
    add_index :ability_permissions, :identifier, unique: true
  end
end