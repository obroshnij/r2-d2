class Ability::Permission < ActiveRecord::Base
  self.table_name = 'ability_permissions'
  
  belongs_to :permission_group, class_name: 'Ability::PermissionGroup', foreign_key: 'group_id'
  
  store_accessor :attrs, :description, :resource
  
  before_save :set_resource
  
  private
  
  def set_resource
    self.resource = permission_group.resource.name
  end
end