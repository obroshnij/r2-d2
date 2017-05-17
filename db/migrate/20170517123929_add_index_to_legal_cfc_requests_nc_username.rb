class AddIndexToLegalCfcRequestsNcUsername < ActiveRecord::Migration
  def change
    add_index :legal_cfc_requests, :nc_username
  end
end
