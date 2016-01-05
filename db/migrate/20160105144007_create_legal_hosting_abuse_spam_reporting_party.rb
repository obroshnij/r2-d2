class CreateLegalHostingAbuseSpamReportingParty < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_reporting_parties do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
