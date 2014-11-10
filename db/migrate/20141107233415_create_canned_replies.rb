class CreateCannedReplies < ActiveRecord::Migration
  def change
    create_table :canned_replies do |t|
      t.string :name
      t.text :description
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
