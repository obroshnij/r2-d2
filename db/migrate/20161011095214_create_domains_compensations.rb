class CreateDomainsCompensations < ActiveRecord::Migration
  def change
    create_table :domains_compensations do |t|
      t.integer :submitted_by_id
      t.string  :reference_id
      t.string  :reference_item
      t.integer :product_id
      t.integer :product_compensated_id
      t.integer :service_compensated_id
      t.integer :hosting_type_id
      t.integer :issue_level_id
      t.integer :compensation_type_id
      t.boolean :discount_recurring
      t.float   :compensation_amount
      t.integer :tier_pricing_id
      t.boolean :client_satisfied
      t.text    :comments

      t.timestamps null: false
    end
  end
end
