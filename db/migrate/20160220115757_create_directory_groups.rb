class CreateDirectoryGroups < ActiveRecord::Migration
  def change
    create_table :directory_groups do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
