class CreateLegalHostingAbuseResellerPlan < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_reseller_plans do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
