class CreateVipDomains < ActiveRecord::Migration
  def change
    create_table :vip_domains do |t|
      t.string :domain
      t.string :username
      t.string :category
      t.string :notes

      t.timestamps
    end
  end
end