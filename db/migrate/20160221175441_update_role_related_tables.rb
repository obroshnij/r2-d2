class UpdateRoleRelatedTables < ActiveRecord::Migration
  def change
    ## Users table
    add_column    :users, :uid,                    :string
    add_column    :users, :role_id,                :integer
    add_column    :users, :auto_role,              :boolean,  default: true
    
    remove_column :users, :reset_password_token,   :string
    remove_column :users, :reset_password_sent_at, :datetime
    
    ## Roles table
    add_column    :roles, :group_ids,              :integer,  array: true,   default: []
    
    ## Roles <-> Users join table
    drop_table :roles_users do |t|
    end
  end
end
