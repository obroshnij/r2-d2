class UserRelation < ActiveRecord::Base
  
  belongs_to :nc_user
  belongs_to :related_user, class_name: "NcUser"
  has_and_belongs_to_many :relation_type
  has_and_belongs_to_many :abuse_reports
  
  def self.link_users(username1, username2, relation_type)
    self.find_or_create_by nc_user_id: NcUser.find_or_create_by(username: username2).id,
                           related_user_id: NcUser.find_or_create_by(username: username1).id,
                           relation_type_id: relation_type.id
    self.find_or_create_by nc_user_id: NcUser.find_or_create_by(username: username1).id,
                           related_user_id: NcUser.find_or_create_by(username: username2).id,
                           relation_type_id: relation_type.id
  end
  
end