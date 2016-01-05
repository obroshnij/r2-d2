class CreateLegalHostingAbuse < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse do |t|
      t.integer :service_id
      t.integer :type_id
      t.integer :management_type_id
      t.integer :reseller_plan_id
      t.integer :shared_plan_id
      t.integer :suggestion_id
      
      t.timestamps null: false
    end
  end
end
