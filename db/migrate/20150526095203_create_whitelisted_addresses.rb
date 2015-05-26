class CreateWhitelistedAddresses < ActiveRecord::Migration
  def change
    create_table :whitelisted_addresses do |t|
      t.string :value
      
      t.timestamps
    end
  end
end
