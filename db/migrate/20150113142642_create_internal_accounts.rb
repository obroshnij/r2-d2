class CreateInternalAccounts < ActiveRecord::Migration
  def change
    create_table :internal_accounts do |t|
      t.string :username
      t.text :comment

      t.timestamps
    end
  end
end
