class CreateLegalHostingAbuseResourceImpact < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_impacts do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
