class CreateBulkRelations < ActiveRecord::Migration
  def change
    create_table :bulk_relations do |t|
      t.references :abuse_report
      t.integer    :nc_user_ids, array: true
      t.integer    :relation_type_ids, array: true

      t.timestamps null: false
    end
  end
end
