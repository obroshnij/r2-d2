class Role < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  has_many :permissions
  
  accepts_nested_attributes_for :permissions
  
  def self.all_without_admin
    self.all - [self.find_by_name("Admin")]
  end
  
  def self.for_user user
    return find(user.role_id) unless user.auto_role
    roles = where(group_ids: user.group_ids)
    roles.present? ? roles.first : find_by_name('Other')
  end
  
  def group_ids= ids
    super ids.delete_if { |id| id.blank? }
  end
  
end