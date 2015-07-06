 class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles
  has_many :permissions, through: :roles
  has_many :background_jobs

  validates :name, :role_ids, presence: true
  
  def admin?
    self.role_ids.include? Role.find_by_name("Admin").id
  end
  
  def accessible_roles
    return Role.all if self.admin?
    Permission.where(role_id: self.role_ids, subject_class: "role").map { |p| Role.where id: p.subject_ids }.flatten.uniq
  end
  
  def role_id
    self.role_ids.first
  end
  
  def role_id=(id)
    self.role_ids = id.present? ? [id] : []
  end
  
end