class CreateLegalHostingAbuseLogs < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_logs do |t|
      t.integer :report_id
      t.integer :user_id
      t.string  :action
      t.text    :comment
      
      t.timestamps null: false
    end
  end
end
