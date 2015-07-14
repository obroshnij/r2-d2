class UserRelation < ActiveRecord::Base
  
  belongs_to :nc_user
  belongs_to :related_user, class_name: "NcUser"
  belongs_to :relation_type
  
  def self.link_users(user_id_1, user_id_2, relation_type_ids)
    relation_type_ids.each do |type_id|
      self.find_or_create_by nc_user_id: user_id_1, related_user_id: user_id_2, relation_type_id: type_id
      self.find_or_create_by nc_user_id: user_id_2, related_user_id: user_id_1, relation_type_id: type_id
    end
  end
  
end