class CreateDomainsCompensationTierPricings < ActiveRecord::Migration
  def change
    create_table :domains_compensation_tier_pricings do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
