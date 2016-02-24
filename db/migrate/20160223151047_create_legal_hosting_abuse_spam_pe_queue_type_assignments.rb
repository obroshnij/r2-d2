class CreateLegalHostingAbuseSpamPeQueueTypeAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_pe_queue_type_assignments do |t|
      t.integer :pe_spam_id
      t.integer :pe_queue_type_id
      
      t.timestamps null: false
    end
  end
end