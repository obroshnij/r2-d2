class CreateToolsInternalDomain < ActiveRecord::Migration
  def change
    create_table :tools_internal_domains do |t|
      t.string :name
      t.text   :comment
      
      t.timestamps null: false
    end
  end
end
