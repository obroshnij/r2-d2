class CreateLegalCfcRequestRelations < ActiveRecord::Migration
  def change
    create_table :legal_cfc_request_relations do |t|
      t.integer :request_id
      t.string  :username
      t.integer :certainty
      t.text    :comment
    end
  end
end
