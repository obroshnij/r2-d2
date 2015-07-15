class NcUser < ActiveRecord::Base
  
  has_many :user_relations
  has_many :related_users, through: :user_relations
  has_many :abuse_reports
  has_many :nc_services
  has_many :comments, as: :commentable
  
  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false, message: "has already been added" }
  validates :signed_up_on_string, format: { with: /\d{1,2}\/\d{1,2}\/\d{4}/, message: "can't be blank / is invalid" }, allow_nil: true
  
  accepts_nested_attributes_for :comments
  
  before_save do
    self.username = self.username.strip.downcase
  end
  
  def signed_up_on_string
    self.signed_up_on.try(:strftime, "%m/%d/%Y")
  end
  
  def signed_up_on_string=(date)
    self.signed_up_on = date.present? ? (Date.strptime(date.strip, "%m/%d/%Y") rescue nil) : nil
  end
  
  def new_status
    nil
  end
  
  def new_status=(status_id)
    self.status_ids = (self.status_ids + [status_id.to_i]).uniq
  end
  
  def delete_status=(status_id)
    self.status_ids = self.status_ids - [status_id]
  end
  
  def status_names
    self.status_ids.map { |id| Status.find id }.map(&:name).join(', ')
  end
  
  def related_users_hash
    self.user_relations.each_with_object({}) do |r, h|
      h[r.related_user.username] ||= []
      h[r.related_user.username] << r.relation_type.name
    end
  end
  
end