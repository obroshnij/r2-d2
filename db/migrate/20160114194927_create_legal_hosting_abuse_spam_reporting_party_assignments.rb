class CreateLegalHostingAbuseSpamReportingPartyAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_reporting_party_assignments do |t|
      t.integer :spam_id
      t.integer :reporting_party_id
      
      t.timestamps null: false
    end
  end
end
