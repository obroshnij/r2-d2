class CreateLegalHostingAbuseDdos < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_ddos do |t|
      t.integer :report_id
      t.integer :block_type_id
      t.boolean :inbound
      t.string  :domain_port
      t.string  :other_block_type
      t.string  :rule
      t.text    :logs
      
      t.timestamps null: false
    end
  end
end
