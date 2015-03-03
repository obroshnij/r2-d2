 class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles
  has_many :reported_domains

  validates :name, :role_ids, presence: true

  def role?(role)
    self.roles.find_by_name(role.to_s.camelize)
  end
  
end