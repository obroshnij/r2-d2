class AddDepartmentToDomainsCompensations < ActiveRecord::Migration
  def change
    add_column :domains_compensations, :department, :string, index: true
  end
end
