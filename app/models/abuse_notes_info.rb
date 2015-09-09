class AbuseNotesInfo < ActiveRecord::Base
  # Abuse Notes
  
  belongs_to :abuse_report
  
end