class CreateDomainsCompensationTypes < ActiveRecord::Migration
  def change
    create_table :domains_compensation_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
