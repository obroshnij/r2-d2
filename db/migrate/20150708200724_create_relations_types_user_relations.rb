class CreateRelationsTypesUserRelations < ActiveRecord::Migration
  def change
    create_table :relations_types_user_relations, id: false do |t|
      t.references :relations_types, :user_relations
    end
  end
end
