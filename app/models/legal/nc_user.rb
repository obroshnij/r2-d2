class Legal::NcUser < ActiveRecord::Base

  self.table_name = 'nc_users'

  has_many :report_assignments, -> {unscope(where: :reportable_type).where(reportable_type: 'NcUser')}, as: :reportable
  has_many :abuse_reports, -> {unscope(where: :reportable_type)}, through: :report_assignments
  has_many :nc_services
  has_many :comments, as: :commentable
  
  accepts_nested_attributes_for :comments
  
  before_save do
    self.username = self.username.strip.downcase
    self.status_ids.uniq!
  end
  
  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }
  
  def destroy
    super unless self.report_assignments.present? || self.nc_services.present? || self.comments.present? ||
                 self.status_ids.include?(Status.find_by_name('Internal Account')) || self.status_ids.include?(Status.find_by_name('VIP')) ||
                 self.status_ids.include?(Status.find_by_name('Has VIP Domains'))
  end
  
  def signed_up_on_string
    self.signed_up_on.try(:strftime, "%m/%d/%Y")
  end
  
  def signed_up_on_string=(date)
    self.signed_up_on = date.present? ? (date.to_date rescue nil) : nil
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
  
  def related_report_ids
    ids = []
    new_ids = self.abuse_reports.map(&:id)
    while new_ids.present?
      new_ids = new_ids.map { |id| AbuseReport.find(id).related_reports.map(&:id) }.flatten.uniq
      new_ids -= ids
      ids += new_ids
    end
    ids
  end
  
  def user_relations
    nodes, edges = [], []
    self.related_report_ids.each do |id|
      report = AbuseReport.find(id)
      nodes += report.nc_users.map { |user| { id: user.id, label: user.username } }
      if report.direct_user_assignments.present? && report.indirect_user_assignments.present?
        direct = report.direct_user_assignments.first
        report.indirect_user_assignments.each do |indirect|
          edges << { from: direct.reportable.id, to: indirect.reportable.id, label: indirect.relation_type_ids.map { |id| RelationType.find(id).short_name }.join(', ') }
        end
      end
    end
    { nodes: nodes.uniq, edges: edges.uniq }
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