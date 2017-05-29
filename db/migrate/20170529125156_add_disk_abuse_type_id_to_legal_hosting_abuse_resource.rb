class AddDiskAbuseTypeIdToLegalHostingAbuseResource < ActiveRecord::Migration
  def change
    add_column :legal_hosting_abuse_resource, :disk_abuse_type_id, :integer
    add_column :legal_hosting_abuse_resource, :db_name,            :string
    add_column :legal_hosting_abuse_resource, :db_size,            :float
  end
end
