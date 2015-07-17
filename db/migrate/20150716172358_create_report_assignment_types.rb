class CreateReportAssignmentTypes < ActiveRecord::Migration
  def change
    create_table :report_assignment_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
