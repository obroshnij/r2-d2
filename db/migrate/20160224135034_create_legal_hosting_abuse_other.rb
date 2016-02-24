class CreateLegalHostingAbuseOther < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_other do |t|
      t.integer :report_id
      t.string  :domain_name
      t.string  :url
      t.text    :logs
      
      t.timestamps null: false
    end
  end
end
