class AddCheckedAtToDomainsCompensations < ActiveRecord::Migration
  def change
    add_column :domains_compensations, :checked_at, :datetime
  end
end
