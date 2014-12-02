class CreateCannedParts < ActiveRecord::Migration
  def change
    create_table :canned_parts do |t|
      t.belongs_to :canned_reply
      t.string :name
      t.string :dependency
      t.text :text

      t.timestamps
    end
  end
end
