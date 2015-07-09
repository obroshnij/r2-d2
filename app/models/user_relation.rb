class UserRelation < ActiveRecord::Base
  
  belongs_to :nc_user
  belongs_to :related_user, class_name: "NcUser"
  belongs_to :relation_type
  
  def self.link_users(username1, username2, relation_type_ids)
    user1_id = NcUser.find_or_create_by(username: username1).id
    user2_id = NcUser.find_or_create_by(username: username2).id
    self.find_or_create_by nc_user_id: user2_id, related_user_id: user1_id, relation_type_ids: relation_type_ids
    self.find_or_create_by nc_user_id: user1_id, related_user_id: user2_id, relation_type_ids: relation_type_ids
  end
  
end