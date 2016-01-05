class CreateLegalHostingAbuseSpamDetectionMethod < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_detection_methods do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
