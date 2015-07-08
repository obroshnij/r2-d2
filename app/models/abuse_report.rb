class AbuseReport < ActiveRecord::Base
  
  belongs_to :abuse_report_status
  belongs_to :abuse_report_type
  belongs_to :nc_user
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by"
  belongs_to :processed_by, class_name: "User", foreign_key: "processed_by"
  has_and_belongs_to_many :user_relations
  
  has_one :spammer_info
  
end