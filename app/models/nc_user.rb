class NcUser < ActiveRecord::Base
  
  has_many :user_relations
  has_many :related_users, through: :user_relations
  has_many :report_assignments, as: :reportable
  has_many :abuse_reports, through: :report_assignments
  has_many :nc_services
  has_many :comments, as: :commentable
  
  validates :username, presence: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/ }
  # validates :username, uniqueness: { case_sensitive: false, message: 'has already been added' }
  validates :signed_up_on_string, format: { with: /\d{1,2}\/\d{1,2}\/\d{4}/, message: "can't be blank / is invalid" }, allow_nil: true
  
  accepts_nested_attributes_for :comments
  
  before_save do
    self.username = self.username.strip.downcase
    self.status_ids.uniq!
  end
  
  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }
  
  def signed_up_on_string
    self.signed_up_on.try(:strftime, "%m/%d/%Y")
  end
  
  def signed_up_on_string=(date)
    self.signed_up_on = date.present? ? (Date.strptime(date.strip, "%m/%d/%Y") rescue nil) : nil
  end
  
  def new_status
    self.status_ids.last
  end
  
  def new_status=(status_id)
    self.status_ids << status_id.to_i
  end
  
  def delete_status=(status_id)
    self.status_ids = self.status_ids - [status_id]
  end
  
  def status_names
    self.status_ids.map { |id| Status.find id }.map(&:name)
  end
  
  def status_icons
    status_names.map { |name| status_icon(name) }.join(' ').html_safe if status_names.present?
  end
  
  def related_users_hash
    self.user_relations.each_with_object({}) do |r, h|
      h[r.related_user.username] ||= []
      h[r.related_user.username] << r.relation_type.try(:name)
    end
  end
  
  private
  
  def status_icon(status_name)
    helpers = ActionController::Base.helpers
    return helpers.content_tag(:i, '', class: 'fa fa-user-secret action', title: status_name) if status_name == "Internal Spammer"
    return helpers.content_tag(:i, '', class: 'fi-link action', title: status_name)           if status_name == "Spammer Related"
    return helpers.content_tag(:i, '', class: 'fi-skull action', title: status_name)          if status_name == "DNS DDoSer"
    return helpers.content_tag(:i, '', class: 'fa fa-link action', title: status_name)        if status_name == "DDoSer Related"
    return helpers.content_tag(:i, '', class: 'fi-mail action', title: status_name)           if status_name == "PE Abuser"
    return helpers.content_tag(:i, '', class: 'fa fa-fire action', title: status_name)        if status_name == "Has Abuse Notes"
    return helpers.content_tag(:i, '', class: 'fi-crown action', title: status_name)          if status_name == "Has VIP Domains"
    return helpers.content_tag(:i, '', class: 'fa fa-home action', title: status_name)        if status_name == "Internal Account"
    return helpers.content_tag(:i, '', class: 'fa fa-diamond action', title: status_name)     if status_name == "VIP"
  end
  
end