class CreateWatchedDomains < ActiveRecord::Migration
  def change
    create_table :watched_domains do |t|
      t.string :name
      t.string :status, array: true
      t.text   :comment
      
      t.timestamps null: false
    end
  end
end
