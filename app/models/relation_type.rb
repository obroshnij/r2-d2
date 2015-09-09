class RelationType < ActiveRecord::Base
  
  has_many :user_relations
  
  def short_name
    return 'IP'    if self.id == 1
    return 'Email' if self.id == 5
    self.name
  end
  
end