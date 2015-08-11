class AddColumnsToDdosInfos < ActiveRecord::Migration
  def change
    add_column :ddos_infos, :target_service, :string
    add_column :ddos_infos, :random_domains, :boolean
    remove_column :ddos_infos, :affected_domains
  end
end