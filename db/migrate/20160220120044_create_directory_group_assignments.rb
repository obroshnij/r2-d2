class CreateDirectoryGroupAssignments < ActiveRecord::Migration
  def change
    create_table :directory_group_assignments do |t|
      t.integer :user_id
      t.integer :group_id
      
      t.timestamps null: false
    end
  end
end
