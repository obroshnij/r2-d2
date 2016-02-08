class CreateLegalEforwardServers < ActiveRecord::Migration
  def change
    create_table :legal_eforward_servers do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
