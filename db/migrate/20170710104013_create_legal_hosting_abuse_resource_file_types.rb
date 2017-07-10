class CreateLegalHostingAbuseResourceFileTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_file_types do |t|
      t.string :name
    end
  end
end
