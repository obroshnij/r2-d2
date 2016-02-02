class LegalHostingAbuseSpamQueueTypeAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_queue_type_assignments do |t|
      t.integer :spam_id
      t.integer :queue_type_id
      
      t.timestamps null: false
    end
  end
end