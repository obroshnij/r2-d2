class CreateLegalHostingAbuseResourceMeasureAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_measure_assignments do |t|
      t.integer :resource_id
      t.integer :measure_id
      
      t.timestamps null: false
    end
  end
end
