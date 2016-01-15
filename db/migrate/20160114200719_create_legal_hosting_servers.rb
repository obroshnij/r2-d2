class CreateLegalHostingServers < ActiveRecord::Migration
  def change
    create_table :legal_hosting_servers do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end