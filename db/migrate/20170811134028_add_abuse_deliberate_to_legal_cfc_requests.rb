class AddAbuseDeliberateToLegalCfcRequests < ActiveRecord::Migration
  def change
    add_column :legal_cfc_requests, :abuse_deliberate, :boolean
  end
end
