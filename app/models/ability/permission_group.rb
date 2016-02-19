class Ability::PermissionGroup < ActiveRecord::Base
  self.table_name = 'ability_permission_groups'
  
  belongs_to :resource,    class_name: 'Ability::Resource',   foreign_key: 'resource_id'
  has_many   :permissions, class_name: 'Ability::Permission', foreign_key: 'group_id'
end