class PrivateEmailInfo < ActiveRecord::Base
  # PE Abuse
  
  belongs_to :abuse_report
  
end