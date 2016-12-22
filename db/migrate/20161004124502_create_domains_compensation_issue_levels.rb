class CreateDomainsCompensationIssueLevels < ActiveRecord::Migration
  def change
    create_table :domains_compensation_issue_levels do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
