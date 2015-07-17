class CreateAbuseNotesInfos < ActiveRecord::Migration
  def change
    create_table :abuse_notes_infos do |t|
      t.references :abuse_report
      t.string     :reported_by
      
      t.timestamps null: false
    end
  end
end
