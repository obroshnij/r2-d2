class Role < ActiveRecord::Base
  
  has_many :users
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  before_validation do
    self.name = name.strip.capitalize
  end
  
  def self.for_user user
    return find(user.role_id) unless user.auto_role
    guess_role user
  end
  
  def permissions
    Ability::Permission.where identifier: permission_ids
  end
  
  def group_ids= ids
    super ids.delete_if { |id| id.blank? }
  end
  
  def permission_ids= ids
    super ids.delete_if { |id| id.blank? }
  end
  
  def users_names
    users.pluck :name
  end
  
  private
  
  def self.guess_role user
    roles = where("group_ids <@ ARRAY[?]::integer[] AND array_length(group_ids, 1) > 0", user.group_ids).order("array_length(group_ids, 1) DESC")
    roles.present? ? roles.first : find_by_name('Other')
  end
  
end