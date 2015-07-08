class CreateAbuseReportTypes < ActiveRecord::Migration
  def change
    create_table :abuse_report_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
