class NcService < ActiveRecord::Base
  
  belongs_to :nc_user
  belongs_to :nc_service_type
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
  
  def new_status
    nil
  end
  
  def new_status=(status_id)
    self.status_ids = (self.status_ids + [status_id.to_i]).uniq
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