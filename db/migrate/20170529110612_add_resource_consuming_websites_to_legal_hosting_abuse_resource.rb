class AddResourceConsumingWebsitesToLegalHostingAbuseResource < ActiveRecord::Migration
  def change
    add_column :legal_hosting_abuse_resource, :resource_consuming_websites, :string, array: true, default: []
  end
end
