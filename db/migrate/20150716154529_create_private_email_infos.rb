class CreatePrivateEmailInfos < ActiveRecord::Migration
  def change
    create_table :private_email_infos do |t|
      t.references :abuse_report
      t.boolean    :suspended
      t.string     :reported_by
      t.string     :warning_ticket_id

      t.timestamps null: false
    end
  end
end
