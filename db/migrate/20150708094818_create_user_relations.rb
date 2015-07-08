class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.references :nc_user
      t.references :related_user
      t.references :relation_type

      t.timestamps null: false
    end
  end
end