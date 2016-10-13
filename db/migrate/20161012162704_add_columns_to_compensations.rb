class AddColumnsToCompensations < ActiveRecord::Migration
  def change
    add_column :domains_compensations, :status,         :integer
    add_column :domains_compensations, :checked_by_id,  :integer
    add_column :domains_compensations, :used_correctly, :boolean
    add_column :domains_compensations, :delivered,      :boolean
    add_column :domains_compensations, :qa_comments,    :text
  end
end
