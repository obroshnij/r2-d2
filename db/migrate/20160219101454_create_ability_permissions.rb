class CreateAbilityPermissions < ActiveRecord::Migration
  def change
    create_table :ability_permissions do |t|
      t.integer :group_id
      t.string  :action
      t.string  :conditions, default: ''
      t.jsonb   :attrs,      default: {}
      
      t.timestamps null: false
    end
  end
end
