class CreateHostingAbuseDiscSpaces < ActiveRecord::Migration
  def change
    create_table :hosting_abuse_disc_spaces do |t|

      t.timestamps null: false
    end
  end
end
