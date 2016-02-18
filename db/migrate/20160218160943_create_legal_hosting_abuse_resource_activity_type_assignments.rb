class CreateLegalHostingAbuseResourceActivityTypeAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_activity_type_assignments do |t|
      t.integer :resource_id
      t.integer :activity_type_id
      
      t.timestamps null: false
    end
  end
end
