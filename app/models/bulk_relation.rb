class BulkRelation < ActiveRecord::Base
  
  belongs_to :abuse_report
  
  validates :usernames, :nc_user_ids, :relation_type_ids, presence: true
  
  before_validation do
    self.relation_type_ids.compact!
  end
  
  after_save do
    self.nc_user_ids.each do |user_id|
      UserRelation.link_users self.abuse_report.nc_user_id, user_id, self.relation_type_ids
    end
  end
  
  def usernames
    self.nc_user_ids.map { |id| NcUser.find(id) }.map(&:username) if self.nc_user_ids.present?
  end
  
  def usernames=(usernames)
    self.nc_user_ids = usernames.downcase.scan(/[a-z0-9]+/).map { |username| NcUser.find_or_create_by(username: username) }.map(&:id)
  end
  
end