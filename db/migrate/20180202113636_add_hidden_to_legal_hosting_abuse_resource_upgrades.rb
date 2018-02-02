class AddHiddenToLegalHostingAbuseResourceUpgrades < ActiveRecord::Migration
  def change
    add_column :legal_hosting_abuse_resource_upgrades, :hidden, :boolean, default: false
  end
end
