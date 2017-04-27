class AddIndexesToUser < ActiveRecord::Migration
  def change
    add_index :users, :uid
    add_index :users, :api_key
  end
end
