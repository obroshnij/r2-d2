class AbuseReportType < ActiveRecord::Base
  
  has_many :abuse_reports
  
  def underscored_name
    self.name.split(' ').join('_').downcase
  end
  
end