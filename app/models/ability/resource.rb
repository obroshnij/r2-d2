class Ability::Resource < ActiveRecord::Base
  self.table_name = 'ability_resources'
  
  has_many :permission_groups, class_name: 'Ability::PermissionGroup', foreign_key: 'resource_id'
end