class CreateLegalHostingAbuseOtherAbuseTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_other_abuse_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
