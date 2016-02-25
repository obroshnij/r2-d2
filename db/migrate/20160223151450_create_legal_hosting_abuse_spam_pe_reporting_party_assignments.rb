class CreateLegalHostingAbuseSpamPeReportingPartyAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_pe_reporting_party_assignments do |t|
      t.integer :pe_spam_id
      t.integer :reporting_party_id
      
      t.timestamps null: false
    end
  end
end
