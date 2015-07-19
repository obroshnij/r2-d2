class ReportAssignment < ActiveRecord::Base
  
  attr_accessor :abuse_report_type
  
  belongs_to :reportable, polymorphic: true
  belongs_to :abuse_report
  
  accepts_nested_attributes_for :reportable
  validates_associated :reportable
  
  validates :usernames, presence: true, if: :usernames_required?
  validates :usernames, format: { with: /\A[\w\d\s,]+\z/, multiline: true, message: "is (are) invalid" }, allow_nil: true, if: :usernames_required?
  
  validates :registered_domains, :free_dns_domains, presence: true, if: :registered_and_free_dns_domains_required?
  validates :registered_domains, :free_dns_domains, numericality: { only_integer: true }, allow_nil: true
  
  validates :domains, presence: true, if: :domains_required?
  
  before_validation do
    init_reportable unless self.new_record?
  end
  
  after_validation do
    init_reportable if self.new_record?
  end
  
  after_create do
    if self.reportable_type == "NcUser" && self.report_assignment_type_id == 2 && self.relation_type_ids.present?
      main_user_id = self.abuse_report.report_assignments.find_by(report_assignment_type_id: 1).try(:reportable_id)
      UserRelation.link_users main_user_id, self.reportable_id, self.relation_type_ids if main_user_id.present?
    end
  end
  
  scope :direct,   -> { where(report_assignment_type_id: 1).uniq }
  scope :indirect, -> { where(report_assignment_type_id: 2).uniq }
  
  # force client side validation
  def run_conditional(method_name_value_or_proc)
    (:usernames_required? == method_name_value_or_proc) || (:registered_and_free_dns_domains_required? == method_name_value_or_proc) ||
    (:domains_required? == method_name_value_or_proc) || super
  end
  
  def usernames_required?
    self.abuse_report_type == "Internal Spammer Blacklist"
  end
  
  def domains_required?
    self.abuse_report_type == "Abuse Notes"
  end
  
  def registered_and_free_dns_domains_required?
    self.abuse_report_type == "FreeDNS DDoS"
  end
  
  def reportable_attributes=(attributes = {})
    self.reportable = self.reportable_type.constantize.new attributes
  end
  
  def split
    return split_by_domains_and_users if self.reportable_type == "NcService" && self.domains.present? && self.usernames.present?
    return split_by_domains           if self.reportable_type == "NcService" && self.domains.present?
    return split_by_usernames         if self.reportable_type == "NcUser"    && self.usernames.present?
    [self]
  end
  
  ## virtual attributes
  
  def usernames
    self.meta_data['usernames']
  end
  
  def usernames=(usernames)
    self.meta_data['usernames'] = usernames.to_s.downcase.scan(/[a-z0-9]+/) if usernames.present?
  end
  
  def username
    self.meta_data['usernames'].try(:first)
  end
  
  def username=(username)
    self.meta_data['usernames'] = [username.strip.downcase] if username.present?
  end
  
  def relation_type_ids
    self.meta_data['relation_type_ids']
  end
  
  def relation_type_ids=(ids)
    ids = ids.delete_if { |el| el.blank? }
    self.meta_data['relation_type_ids'] = ids if ids.present?
  end
  
  def domains
    self.meta_data['domains']
  end
  
  def domains=(domains)
    self.meta_data['domains'] = DomainName.parse_multiple(domains).map(&:name) if domains.present?
  end
  
  def registered_domains
    self.meta_data['registered_domains']
  end
  
  def registered_domains=(domains)
    self.meta_data['registered_domains'] = domains if domains.present?
  end
    
  def free_dns_domains
    self.meta_data['free_dns_domains']
  end
  
  def free_dns_domains=(domains)
    self.meta_data['free_dns_domains'] = domains if domains.present?
  end
    
  def comment
    self.meta_data['comment']
  end
  
  def comment=(comment)
    self.meta_data['comment'] = comment if comment.present?
  end
  
  def new_user_status
    self.meta_data['new_user_status']
  end
  
  def new_user_status=(id)
    self.meta_data['new_user_status'] = id if id.present?
  end

  private
  
  def init_reportable
    reportable = find_or_create_reportable
    if self.reportable.present? && self.reportable.new_status.present?
      reportable.new_status = self.reportable.new_status
      reportable.save
    end
    self.reportable = reportable
  end

  def find_or_create_reportable
    if self.reportable.is_a? NcUser
      return NcUser.find(self.reportable.id) if self.reportable.id.present?
      NcUser.create_with(signed_up_on: self.reportable.signed_up_on).find_or_create_by(username: self.reportable.username.downcase.strip)
    elsif self.reportable.is_a? NcService
      return NcService.find(self.reportable.id) if self.reportable.id.present?
      NcService.create_with(nc_service_type_id: self.reportable.nc_service_type_id).find_or_create_by(name: self.reportable.name.downcase.strip)
    end
  end
  
  def split_by_domains_and_users
    self.usernames.map do |username|
      ReportAssignment.new(reportable_type: "NcUser", report_assignment_type_id: 2, reportable_attributes: { username: username, new_status: self.new_user_status })
    end + split_by_domains
  end
  
  def split_by_domains
    self.domains.map do |name|
      ReportAssignment.new(self.attributes.slice('reportable_type', 'report_assignment_type_id').
        merge({ reportable_attributes: { name: name, nc_service_type_id: 1 } }).merge(self.meta_data.slice(*self.meta_data.keys - ['domains', 'new_user_status'])))
    end
  end
  
  def split_by_usernames
    self.usernames.map do |username|
      ReportAssignment.new(self.attributes.slice('reportable_type', 'report_assignment_type_id').
        merge({ reportable_attributes: { username: username } }).merge(self.meta_data.slice(*self.meta_data.keys - ['usernames'])))
    end
  end
  
end