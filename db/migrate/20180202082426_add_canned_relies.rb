class AddCannedRelies < ActiveRecord::Migration
  def change
    create_table :tools_canned_replies_canned_categories do |t|
      t.string  :name,        null: false
      t.string  :ancestry
      t.boolean :private,     null: false, default: false
      t.integer :user_id
      t.integer :origin_id,   null: false
      t.timestamps
    end

    create_table :tools_canned_replies_macros_categories do |t|
      t.string  :name,        null: false
      t.string  :ancestry
      t.boolean :private,     null: false, default: false
      t.integer :user_id
      t.integer :origin_id,   null: false
      t.timestamps
    end

    add_index :tools_canned_replies_canned_categories, ["origin_id"]
    add_index :tools_canned_replies_macros_categories, ["origin_id"]

    add_index :tools_canned_replies_canned_categories, ["ancestry"], name: "index_canned_categories_on_ancestry", using: :btree
    add_index :tools_canned_replies_macros_categories, ["ancestry"], name: "index_macros_categories_on_ancestry", using: :btree

    create_table :tools_canned_replies_canned_replies do |t|
      t.string  :name,          null: false
      t.text    :content,       null: false
      t.integer :category_id,   null: false
      t.boolean :private,       null: false, default: false
      t.integer :user_id
      t.integer :origin_id,   null: false
      t.timestamps
    end

    create_table :tools_canned_replies_macros_replies do |t|
      t.string  :name,          null: false
      t.text    :content,       null: false
      t.integer :category_id,   null: false
      t.boolean :private,       null: false, default: false
      t.integer :user_id
      t.integer :origin_id,   null: false
      t.timestamps
    end

    add_index :tools_canned_replies_canned_replies, ["origin_id"]
    add_index :tools_canned_replies_macros_replies, ["origin_id"]

    add_index :tools_canned_replies_canned_replies, ["category_id"]
    add_index :tools_canned_replies_macros_replies, ["category_id"]

    add_index :tools_canned_replies_canned_replies, ["user_id"]
    add_index :tools_canned_replies_macros_replies, ["user_id"]

  end
end
