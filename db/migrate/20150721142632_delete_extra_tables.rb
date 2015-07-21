class DeleteExtraTables < ActiveRecord::Migration
  def change
    
    drop_table :vip_domains
    drop_table :spammers
    drop_table :internal_accounts
    
  end
end
