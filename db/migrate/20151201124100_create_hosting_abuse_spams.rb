class CreateHostingAbuseSpams < ActiveRecord::Migration
  def change
    create_table :hosting_abuse_spams do |t|

      t.timestamps null: false
    end
  end
end
