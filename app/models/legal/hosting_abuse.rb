class Legal::HostingAbuse < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse'
  
  enum status: [:unprocessed, :processed, :dismissed]
  
  has_one    :ddos,            class_name: 'Legal::HostingAbuse::Ddos',           foreign_key: 'report_id',         autosave: true
  has_one    :resource,        class_name: 'Legal::HostingAbuse::Resource',       foreign_key: 'report_id',         autosave: true
  has_one    :spam,            class_name: 'Legal::HostingAbuse::Spam',           foreign_key: 'report_id',         autosave: true
  has_one    :pe_spam,         class_name: 'Legal::HostingAbuse::PeSpam',         foreign_key: 'report_id',         autosave: true
  has_one    :other,           class_name: 'Legal::HostingAbuse::Other',          foreign_key: 'report_id',         autosave: true
  
  belongs_to :service,         class_name: 'Legal::HostingAbuse::Service',        foreign_key: 'service_id'
  belongs_to :type,            class_name: 'Legal::HostingAbuse::AbuseType',      foreign_key: 'type_id'
  belongs_to :management_type, class_name: 'Legal::HostingAbuse::ManagementType', foreign_key: 'management_type_id'
  belongs_to :reseller_plan,   class_name: 'Legal::HostingAbuse::ResellerPlan',   foreign_key: 'reseller_plan_id'
  belongs_to :shared_plan,     class_name: 'Legal::HostingAbuse::SharedPlan',     foreign_key: 'shared_plan_id'
  belongs_to :vps_plan,        class_name: 'Legal::HostingAbuse::VpsPlan',        foreign_key: 'vps_plan_id'
  belongs_to :suggestion,      class_name: 'Legal::HostingAbuse::Suggestion',     foreign_key: 'suggestion_id'
  
  belongs_to :reported_by,     class_name: 'User',                                foreign_key: 'reported_by_id'
  belongs_to :processed_by,    class_name: 'User',                                foreign_key: 'processed_by_id'
  belongs_to :server,          class_name: 'Legal::HostingServer',                foreign_key: 'server_id'
  belongs_to :efwd_server,     class_name: 'Legal::EforwardServer',               foreign_key: 'efwd_server_id'
    
  before_save :normalize_attrs
  after_save  :cleanup!
  
  def self.reported_by
    User.where id: select(:reported_by_id).distinct.pluck(:reported_by_id)
  end
  
  def canned_reply
    Legal::HostingAbuse::CannedReply.new(self).render
  end
  
  private
  
  def normalize_attrs
    self.username          = self.username.try(:strip).try(:downcase)
    self.resold_username   = self.resold_username.try(:strip).try(:downcase)
    self.server_rack_label = self.server_rack_label.try(:strip)
    self.subscription_name = self.subscription_name.try(:strip).try(:downcase)
    self.suspension_reason = self.suspension_reason.try(:strip)
    self.scan_report_path  = self.scan_report_path.try(:strip)
    self.tech_comments     = self.tech_comments.try(:strip)
    self.legal_comments    = self.legal_comments.try(:strip)
  end
  
  def cleanup!
    classes = [Legal::HostingAbuse::PeSpam, Legal::HostingAbuse::Spam, Legal::HostingAbuse::Resource, Legal::HostingAbuse::Ddos, Legal::HostingAbuse::Other] - [get_child_class]
    classes.each { |klass| klass.where(report_id: self.id).destroy_all }
  end
  
  def get_child_class
    return Legal::HostingAbuse::PeSpam    if type_id == 1 && service_id == 5
    return Legal::HostingAbuse::Spam      if type_id == 1
    return Legal::HostingAbuse::Resource  if type_id == 2
    return Legal::HostingAbuse::Ddos      if type_id == 3
    return Legal::HostingAbuse::Other     if type_id == 4
  end
  
end