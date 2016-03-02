class CreateLegalKayakoTickets < ActiveRecord::Migration
  def change
    create_table :legal_kayako_tickets do |t|
      t.string :identifier, index: true
      
      t.timestamps null: false
    end
  end
end
