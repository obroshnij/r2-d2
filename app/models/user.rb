 class User < ActiveRecord::Base
  # :registerable, :confirmable, :lockable, :timeoutable, :omniauthable
  # :database_authenticatable, :recoverable, :validatable
  devise :rememberable, :trackable, :database_authenticatable
  
  belongs_to :role
  
  has_many :background_jobs
  has_many :comments
  
  has_many :group_assignments, class_name: 'DirectoryGroupAssignment'
  has_many :groups,            class_name: 'DirectoryGroup',           through: :group_assignments
  
  validates :uid, :name, :email, :role_id, presence: true
  
  def self.from_ldap_entry entry
    user = create_with(email: entry.mail.first).find_or_create_by(uid: entry.uid)
    
    user.group_ids = get_group_ids entry
    user.name      = "#{entry.givenname.first} #{entry.sn.first}"
    user.role_id   = Role.for_user(user).id
    user.save!
    
    user
  end
  
  def admin?
    true
  end
  
  private
  
  def self.get_group_ids entry
    names = (entry.try(:memberof) || []).map do |group_dn|
      group_dn.include?('cn=groups') ? group_dn.split(',').first.split('=').last : nil
    end
    names.compact.keep_if { |group_name| group_name[0..1] == 'nc' }.map do |name|
      DirectoryGroup.find_or_create_by(name: name).id
    end
  end
  
end