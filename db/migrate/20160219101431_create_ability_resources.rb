class CreateAbilityResources < ActiveRecord::Migration
  def change
    create_table :ability_resources do |t|
      t.string :subjects, array: true, default: []
      t.jsonb  :attrs,                 default: {}
      
      t.timestamps null: false
    end
  end
end
