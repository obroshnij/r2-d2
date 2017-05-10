class CreateDomainsCompensationLogs < ActiveRecord::Migration
  def change
    create_table :domains_compensation_logs do |t|
      t.integer :compensation_id
      t.integer :user_id
      t.string  :action
      t.jsonb   :payload

      t.timestamps null: false
    end
  end
end
