class Role < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  has_many :permissions
  
  accepts_nested_attributes_for :permissions
  
  def self.all_without_admin
    self.all - [self.find_by_name("Admin")]
  end
  
end