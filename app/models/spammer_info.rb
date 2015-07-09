class SpammerInfo < ActiveRecord::Base
  
  belongs_to :abuse_report
  has_one :reference_type
  
end