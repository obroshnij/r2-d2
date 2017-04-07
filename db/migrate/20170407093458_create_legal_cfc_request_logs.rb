class CreateLegalCfcRequestLogs < ActiveRecord::Migration
  def change
    create_table :legal_cfc_request_logs do |t|
      t.integer :request_id
      t.integer :user_id
      t.string  :action
      t.text    :comment

      t.timestamps null: false
    end
  end
end
