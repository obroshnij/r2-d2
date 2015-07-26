class AddAffectedDomainsAndImpactToDdosInfos < ActiveRecord::Migration
  def change
    add_column :ddos_infos, :affected_domains, :text
    add_column :ddos_infos, :impact, :string
  end
end
