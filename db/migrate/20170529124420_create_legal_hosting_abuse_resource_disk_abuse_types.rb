class CreateLegalHostingAbuseResourceDiskAbuseTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_disk_abuse_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
