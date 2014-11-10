class AddCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cache, :text, limit: nil
  end
end
