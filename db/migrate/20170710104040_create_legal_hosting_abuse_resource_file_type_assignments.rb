class CreateLegalHostingAbuseResourceFileTypeAssignments < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_file_type_assignments do |t|
      t.integer :resource_id
      t.integer :file_type_id
    end
  end
end
