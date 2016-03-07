class UpdateRoleRelatedTables < ActiveRecord::Migration
  def change
    ## Users table
    add_column    :users, :uid,                    :string
    add_column    :users, :role_id,                :integer
    add_column    :users, :auto_role,              :boolean,  default: true
        
    ## Roles table
    add_column    :roles, :group_ids,              :integer,  array: true,   default: []
    add_column    :roles, :permission_ids,         :string,   array: true,   default: []
  end
end
