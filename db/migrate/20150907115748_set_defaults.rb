class SetDefaults < ActiveRecord::Migration
  def change
    change_column :abuse_reports,       :processed,            :boolean, default: false
    
    change_column :ddos_infos,          :target_service,       :string,  default: 'FreeDNS'
    change_column :ddos_infos,          :impact,               :string,  default: 'Low'
    change_column :ddos_infos,          :random_domains,       :boolean, default: false
    change_column :ddos_infos,          :cfc_status,           :boolean, default: false
    
    change_column :spammer_infos,       :responded_previously, :boolean, default: false
    change_column :spammer_infos,       :cfc_status,           :boolean, default: false
    
    change_column :private_email_infos, :suspended,            :boolean, default: false
  end
end
