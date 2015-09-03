class DropUserRelations < ActiveRecord::Migration
  def change
    drop_table :user_relations
  end
end
