class CreateAbilityResources < ActiveRecord::Migration
  def change
    create_table :ability_resources do |t|
      t.string :name
      t.jsonb  :attrs, default: {}
      
      t.timestamps null: false
    end
  end
end
