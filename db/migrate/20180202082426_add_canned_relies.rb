class AddCannedRelies < ActiveRecord::Migration
  def change
    create_table :tools_canned_replies_categories do |t|
      t.string  :name,        null: false
      t.string  :ancestry
      t.boolean :private,     null: false, default: false
      t.integer :user_id
      t.timestamps
      t.string  :type,        null: false
    end

    add_index :tools_canned_replies_categories, ["ancestry"], name: "index_reply_categories_on_ancestry", using: :btree

    create_table :tools_canned_replies_replies do |t|
      t.string  :name,          null: false
      t.text    :content,       null: false
      t.integer :category_id,   null: false
      t.boolean :private,       null: false, default: false
      t.integer :user_id
      t.timestamps
    end
  end
end
