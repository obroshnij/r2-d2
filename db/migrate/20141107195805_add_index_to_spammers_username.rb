class AddIndexToSpammersUsername < ActiveRecord::Migration
  def change
  	add_index :spammers, :username, unique: true
  end
end
