class NcService < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :nc_service_type
  
end