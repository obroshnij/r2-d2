class CreateAbuseReports < ActiveRecord::Migration
  def change
    create_table :abuse_reports do |t|
      t.references :abuse_report_type
      t.integer    :reported_by
      t.integer    :processed_by
      t.boolean    :processed
      t.text       :comment

      t.timestamps null: false
    end
  end
end
