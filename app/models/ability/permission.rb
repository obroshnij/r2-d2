class Ability::Permission < ActiveRecord::Base
  self.table_name = 'ability_permissions'
  
  belongs_to :resource, class_name: 'Ability::Resource', foreign_key: 'resource_id'
  
  store_accessor :attrs, :description
  
  def subject_classes
    resource.subjects.map do |subject|
      subject.constantize rescue subject.to_sym
    end
  end
  
  def actions
    super.map &:to_sym
  end
end