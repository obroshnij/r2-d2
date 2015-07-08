class SpammerInfo < ActiveRecord::Base
  
  belongs_to :abuse_report
  
end