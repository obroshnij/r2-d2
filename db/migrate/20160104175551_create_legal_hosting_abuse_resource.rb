class CreateLegalHostingAbuseResource < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource do |t|
      t.integer :report_id
      t.integer :impact_id
      t.integer :type_id
      t.integer :upgrade_id
      
      t.timestamps null: false
    end
  end
end
