class DirectoryGroupAssignment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :group, class_name: 'DirectoryGroup', foreign_key: 'group_id'
  
end