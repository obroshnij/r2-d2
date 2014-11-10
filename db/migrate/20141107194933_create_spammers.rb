class CreateSpammers < ActiveRecord::Migration
  def change
    create_table :spammers do |t|
   	  t.string :username
   	  t.string :comment

      t.timestamps
    end
  end
end