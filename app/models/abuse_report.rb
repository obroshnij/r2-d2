class AbuseReport < ActiveRecord::Base
  
  belongs_to :abuse_report_type
  belongs_to :nc_user
  # belongs_to :reported_by, class_name: "User", foreign_key: "reported_by"
  # belongs_to :processed_by, class_name: "User", foreign_key: "processed_by"
  has_many :bulk_relations
  
  has_one :spammer_info
  
  accepts_nested_attributes_for :nc_user, :spammer_info, :bulk_relations
  accepts_nested_attributes_for :bulk_relations, reject_if: :all_blank, allow_destroy: true
  
  validates :reported_by, :nc_user, presence: true
  validates_associated :nc_user, :spammer_info, :bulk_relations
  
  before_validation do
    if self.nc_user.new_record?
      self.nc_user = NcUser.create_with(signed_up_on: self.nc_user.signed_up_on).find_or_create_by(username: self.nc_user.username)
    end
  end
  
end