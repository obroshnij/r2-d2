class CreateLegalUserRelationTypes < ActiveRecord::Migration
  def change
    create_table :legal_user_relation_types do |t|
      t.string :uid, index: true
      t.string :name
    end
  end
end
