class CreateLegalHostingAbuseSpam < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam do |t|
      t.integer :report_id
      t.integer :detection_method_id
      t.integer :content_type_id
      
      t.timestamps null: false
    end
  end
end
