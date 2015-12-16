class CreateHostingAbuseLveMysqls < ActiveRecord::Migration
  def change
    create_table :hosting_abuse_lve_mysqls do |t|

      t.timestamps null: false
    end
  end
end
