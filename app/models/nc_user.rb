class NcUser < ActiveRecord::Base
  
  has_many :user_relations
  has_many :related_users, through: :user_relations
  belongs_to :status
  has_many :nc_services
  
end