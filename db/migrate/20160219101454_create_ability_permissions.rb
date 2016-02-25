class CreateAbilityPermissions < ActiveRecord::Migration
  def change
    create_table :ability_permissions do |t|
      t.string  :identifier
      t.integer :group_id
      t.string  :action
      t.string  :conditions, default: ''
      t.jsonb   :attrs,      default: {}
      
      t.timestamps null: false
    end
    
    add_index :ability_permissions, :identifier, unique: true
  end
end