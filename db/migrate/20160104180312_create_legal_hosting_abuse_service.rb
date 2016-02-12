class CreateLegalHostingAbuseService < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_services do |t|
      t.string :name
      t.jsonb  :properties, default: {}
      
      t.timestamps null: false
    end
  end
end
