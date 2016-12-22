class CreateDomainsCompensationAffectedProducts < ActiveRecord::Migration
  def change

    create_table :domains_compensation_affected_products do |t|
      t.string :name
    end

    add_column :domains_compensations, :affected_product_id, :integer

    Rake::Task['products:create_affected_products'].invoke
    Rake::Task['products:remap'].invoke
    Rake::Task['products:fix_records'].invoke

  end
end
