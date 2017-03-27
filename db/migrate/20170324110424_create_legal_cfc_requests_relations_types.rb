class CreateLegalCfcRequestsRelationsTypes < ActiveRecord::Migration
  def change
    create_table :legal_cfc_requests_relations_types do |t|
      t.integer :relation_id,       index: true
      t.string  :relation_type_uid, index: true
    end
  end
end
