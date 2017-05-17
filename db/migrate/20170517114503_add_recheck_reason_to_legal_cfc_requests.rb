class AddRecheckReasonToLegalCfcRequests < ActiveRecord::Migration
  def change
    add_column :legal_cfc_requests, :recheck_reason, :text
  end
end
