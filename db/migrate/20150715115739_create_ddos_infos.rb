class CreateDdosInfos < ActiveRecord::Migration
  def change
    create_table :ddos_infos do |t|
      t.references :abuse_report
      t.integer    :registered_domains
      t.integer    :free_dns_domains
      t.boolean    :cfc_status
      t.string     :cfc_comment
      t.float      :amount_spent
      t.date       :last_signed_in_on
      t.string     :vendor_ticket_id
      t.string     :client_ticket_id

      t.timestamps null: false
    end
  end
end
