class LegalHostingAbuseSpamContentTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam_content_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
