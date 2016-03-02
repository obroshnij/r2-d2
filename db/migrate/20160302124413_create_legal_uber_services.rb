class CreateLegalUberServices < ActiveRecord::Migration
  def change
    create_table :legal_uber_services do |t|
      t.string :identifier, index: true
      
      t.timestamps null: false
    end
  end
end
