class CreateLegalHostingAbuseOtherAbuseTypeAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_other_abuse_type_assignments do |t|
      t.integer :other_id
      t.integer :abuse_type_id
      
      t.timestamps null: false
    end
  end
end
