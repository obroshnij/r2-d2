class AddIndexToInternalAccountsUsername < ActiveRecord::Migration
  def change
    add_index :internal_accounts, :username, unique: true
  end
end