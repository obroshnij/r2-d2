class CreateHostingAbuseInfos < ActiveRecord::Migration
  def change
    create_table :hosting_abuse_infos do |t|
      

      t.timestamps null: false
    end
  end
end
