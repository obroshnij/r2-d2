class Permission < ActiveRecord::Base
  
  belongs_to :role
  
  before_save do
    self.actions = self.actions.delete_if { |el| el.blank? } unless self.actions.nil?
    if self.subject_class == Role
      self.actions = self.subject_ids == [nil] ? [] : ["read", "update"]
    end
  end
  
  def subject_ids
    if self.subject_class == User
      ids = Permission.find_by(role_id: self.role_id, subject_class: "role").subject_ids
      User.joins("INNER JOIN roles_users ON users.id = roles_users.user_id").where("roles_users.role_id" => ids).select(:id).map(&:id) + [nil]
    else
      super
    end
  end
  
  def possible_actions
    Ability::CLASSES[self.subject_class.to_s.underscore.to_sym]
  end
  
  def subject_class
    super.classify.constantize rescue super.to_sym
  end
  
end