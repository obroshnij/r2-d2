class AddVerifiedByIdToLegalCfcRequests < ActiveRecord::Migration
  def change
    add_column :legal_cfc_requests, :verified_by_id,   :integer
    add_column :legal_cfc_requests, :verified_at,      :datetime
    add_column :legal_cfc_requests, :process_comments, :text
  end
end
