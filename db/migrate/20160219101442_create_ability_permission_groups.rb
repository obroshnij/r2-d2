class CreateAbilityPermissionGroups < ActiveRecord::Migration
  def change
    create_table :ability_permission_groups do |t|
      t.integer :resource_id
      t.string  :name
      t.boolean :exclusive,   default: false
      t.jsonb   :attrs,       default: {}
      
      t.timestamps null: false
    end
  end
end
