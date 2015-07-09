class CreateSpammerInfos < ActiveRecord::Migration
  def change
    create_table :spammer_infos do |t|
      t.references :abuse_report
      t.integer    :registered_domains
      t.integer    :abused_domains
      t.integer    :locked_domains
      t.integer    :abused_locked_domains
      t.boolean    :cfc_status
      t.string     :cfc_comment
      t.float      :amount_spent
      t.date       :last_signed_in_on
      t.boolean    :responded_previously
      t.string     :reference_ticket_id

      t.timestamps null: false
    end
  end
end
