class BackgroundJob < ActiveRecord::Base
  
  belongs_to :user
  
  def failed?
    self.status.include? "Failed"
  end
  
  def successful?
    self.status == "Completed"
  end
  
  def pending?
    self.status.include?("Pending") || self.status.include?("will retry")
  end
  
end