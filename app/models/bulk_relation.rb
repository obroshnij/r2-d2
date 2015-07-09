class BulkRelation < ActiveRecord::Base
  
  belongs_to :abuse_report
  
  def usernames
    self.nc_user_ids.present? ? self.nc_user_ids.map { |id| NcUser.find(id) }.map(&:username) : ""
  end
  
  def usernames=(usernames)
    self.nc_user_ids = usernames.downcase.split.map { |username| NcUser.find_or_create_by(username) }.map(&:id)
  end
  
end