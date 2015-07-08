class CreateAbuseReportStatuses < ActiveRecord::Migration
  def change
    create_table :abuse_report_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
