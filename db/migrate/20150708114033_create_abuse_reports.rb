class CreateAbuseReports < ActiveRecord::Migration
  def change
    create_table :abuse_reports do |t|
      t.references :nc_user
      t.references :abuse_report_status
      t.references :abuse_report_type
      t.integer    :reported_by
      t.integer    :processed_by
      t.text       :comment

      t.timestamps null: false
    end
  end
end
