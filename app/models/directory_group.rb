class DirectoryGroup < ActiveRecord::Base
  
  has_many :group_assignments, class_name: 'DirectoryGroupAssignment', foreign_key: 'group_id'
  has_many :users,             through: :group_assignments
  
end