class CreateLegalHostingAbuseDdosBlockType < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_ddos_block_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
