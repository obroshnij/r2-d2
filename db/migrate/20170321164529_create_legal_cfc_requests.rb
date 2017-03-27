class CreateLegalCfcRequests < ActiveRecord::Migration
  def change
    create_table :legal_cfc_requests do |t|
      t.integer  :submitted_by_id
      t.integer  :processed_by_id
      t.datetime :processed_at
      t.integer  :status
      t.string   :verification_ticket_id
      t.string   :nc_username
      t.date     :signup_date
      t.integer  :request_type
      t.integer  :find_relations_reason
      t.string   :reference
      t.integer  :service_type
      t.string   :domain_name
      t.string   :service_id
      t.string   :pe_subscription
      t.integer  :abuse_type
      t.text     :other_description
      t.integer  :service_status
      t.string   :service_status_reference
      t.text     :comments
      t.boolean  :frauded
      t.integer  :relations_status

      t.timestamps null: false
    end
  end
end
