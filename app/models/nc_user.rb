class NcUser < ActiveRecord::Base
  
  has_many :user_relations
  has_many :related_users, through: :user_relations
  has_many :nc_services
  
  validates :username, presence: true
  validates :signed_up_on_string, format: { with: /\d{1,2}\/\d{1,2}\/\d{4}/, message: "can't be blank / is invalid" }, allow_nil: true
  
  before_save do
    self.username = self.username.strip.downcase
  end
  
  def signed_up_on_string
    self.signed_up_on.try(:strftime, "%m/%d/%Y")
  end
  
  def signed_up_on_string=(date)
    self.signed_up_on = date.present? ? (Date.strptime(date.strip, "%m/%d/%Y") rescue nil) : nil
  end
  
  def new_status=(status_id)
    self.status_ids = (self.status_ids + [status_id.to_i]).uniq
  end
  
end