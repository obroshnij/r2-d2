class AddInternalInvestigationApprovedByIdToLegalCfcRequests < ActiveRecord::Migration
  def change
    add_column :legal_cfc_requests, :investigation_approved_by_id, :integer
    add_column :legal_cfc_requests, :investigate_unless_fraud,     :boolean
    add_column :legal_cfc_requests, :certainty_threshold,          :integer
  end
end
