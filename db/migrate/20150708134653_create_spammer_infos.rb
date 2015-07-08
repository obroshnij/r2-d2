class CreateSpammerInfos < ActiveRecord::Migration
  def change
    create_table :spammer_infos do |t|
      t.references :abuse_report
      t.integer    :registered_domains
      t.integer    :abused_domains
      t.string     :cfc_status
      t.float      :amount_spent
      t.boolean    :responded_previously
      t.string     :reference

      t.timestamps null: false
    end
  end
end
