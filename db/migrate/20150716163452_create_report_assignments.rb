class CreateReportAssignments < ActiveRecord::Migration
  def change
    create_table :report_assignments do |t|
      t.references :reportable, polymorphic: true, index: true
      t.references :abuse_report
      t.references :report_assignment_type
      t.jsonb      :meta_data, default: {}
      
      t.timestamps null: false
    end
  end
end
