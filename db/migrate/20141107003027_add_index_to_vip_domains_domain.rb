class AddIndexToVipDomainsDomain < ActiveRecord::Migration
  def change
  	add_index :vip_domains, :domain, unique: true
  end
end
