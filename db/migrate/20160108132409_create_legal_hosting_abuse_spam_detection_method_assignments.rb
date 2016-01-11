class CreateLegalHostingAbuseSpamDetectionMethodAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_detection_method_assignments do |t|
      t.integer :spam_id
      t.integer :detection_method_id
      
      t.timestamps null: false
    end
  end
end
