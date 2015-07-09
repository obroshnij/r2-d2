class AbuseReport < ActiveRecord::Base
  
  belongs_to :abuse_report_status
  belongs_to :abuse_report_type
  belongs_to :nc_user
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by"
  belongs_to :processed_by, class_name: "User", foreign_key: "processed_by"
  has_many :bulk_relations
  
  has_one :spammer_info
  
  accepts_nested_attributes_for :bulk_relations, reject_if: :all_blank, allow_destroy: true
  
  # before_validation do
  #   self.set_relations
  # end
  #
  # def bulk_relation_types
  #   return @bulk_relation_types if @bulk_relation_types.present?
  #   self.user_relations.map(&:relation_type_ids).flatten.uniq
  # end
  #
  # def bulk_relation_types=(type_ids)
  #   @bulk_relation_types = type_ids
  # end
  #
  # def bulk_related_users
  #   return @bulk_related_users if @bulk_related_users.present?
  #   self.user_relations.map(&:related_user_id).map { |id| NcUser.find(id) }.map(&:username).join(", ")
  # end
  #
  # def bulk_related_users=(usernames)
  #   @bulk_related_users = usernames.split
  # end
  #
  # def set_relations
  #   if @bulk_relation_types.present? && @bulk_related_users.present? && self.nc_user.present?
  #     @bulk_related_users.each do |username|
  #       self.user_relations << UserRelation.link_users(nc_user.username, username, @bulk_relation_types)
  #     end
  #   end
  # end
  
end