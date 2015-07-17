class NcService < ActiveRecord::Base
  
  belongs_to :nc_user
  belongs_to :nc_service_type
  has_many :report_assignments, as: :reportable
  has_many :abuse_reports, through: :report_assignments
  has_many :comments, as: :commentable
  
  before_save do
    self.name = self.name.strip.downcase
  end
  
  after_save do
    if self.nc_service_type.id == 1 && self.status_ids.include?(1)
      self.nc_user.new_status = Status.find_by(name: "Has VIP Domains").id
      self.nc_user.save
    end
  end
  
  after_destroy do
    if self.nc_service_type.id == 1 && self.status_ids.include?(1) && self.nc_user.nc_services.where(nc_service_type_id: 1).where.contains(status_ids: [1]).blank?
      self.nc_user.delete_status = Status.find_by(name: "Has VIP Domains").id
      self.nc_user.save
    end
  end
  
  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }
  
  def new_status
    self.status_ids.last
  end
  
  def new_status=(status_id)
    self.status_ids << status_id.to_i
  end
  
  def status_names
    self.status_ids.map { |id| ServiceStatus.find id }.map(&:name).join(', ')
  end
  
  def username
    self.nc_user.try(:username)
  end
  
  def username=(username)
    self.nc_user = NcUser.find_or_create_by(username: username.strip.downcase)
  end
  
end