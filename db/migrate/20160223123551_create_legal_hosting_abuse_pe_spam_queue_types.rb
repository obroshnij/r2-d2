class CreateLegalHostingAbusePeSpamQueueTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_pe_spam_queue_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
