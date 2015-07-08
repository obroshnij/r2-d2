class AbuseReportStatus < ActiveRecord::Base
  
  has_many :abuse_reports
  
end