class CreateLegalHostingAbuseSpamPeContentTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_pe_content_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
