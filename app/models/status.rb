class Status < ActiveRecord::Base
  
  has_many :nc_users
  
end