class Ability::Resource < ActiveRecord::Base
  self.table_name = 'ability_resources'
  
  has_many :permissions, class_name: 'Ability::Permission', foreign_key: 'resource_id'
  
  store_accessor :attrs, :description
end