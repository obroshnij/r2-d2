class AddEmailToWatchedDomains < ActiveRecord::Migration
  def change
    add_column :watched_domains, :email, :string
  end
end
