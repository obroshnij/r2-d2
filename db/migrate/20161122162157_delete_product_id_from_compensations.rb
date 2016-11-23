class DeleteProductIdFromCompensations < ActiveRecord::Migration
  def change
    remove_column :domains_compensations, :product_id, :integer
  end
end
