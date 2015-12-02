class CreateHostingAbuseCronJobs < ActiveRecord::Migration
  def change
    create_table :hosting_abuse_cron_jobs do |t|

      t.timestamps null: false
    end
  end
end
