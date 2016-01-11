class CreateLegalHostingAbuseResourceAbuseTypeAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_abuse_type_assignments do |t|
      t.integer :resource_id
      t.integer :abuse_type_id
      
      t.timestamps null: false
    end
  end
end
